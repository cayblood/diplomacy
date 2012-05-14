require "tsort"

class Hash
 include TSort
 alias tsort_each_node each_key
 def tsort_each_child(node, &block)
   dest = fetch(node, nil)
   yield(dest) if dest
 end
end

class Board
  attr_accessor :provinces, :units

  def initialize
    @provinces = {}
  end

  def add_province(province)
    @provinces[province.abbreviation] = province
  end

  def set_unit_state(state_text)
    @units = {}
    state_text.lines.each do |line|
      power, units = line.split(':')
      @units[power] = units.strip.split(',').collect {|unit_text| Unit.new(unit_text, self) }
    end
  end

  def parse_orders(orders)
    returnval = {}
    orders.lines.collect do |order_line|
      power, orders_for_power = order_line.split(':')
      returnval[power] = orders_for_power.split(',').collect {|order| Order.new(order, self) }
    end
    returnval
  end

  def execute_order(order)
    if order.move?
      unit = units[order.power].detect do |u|
        u.province == order.current_province &&
        u.type == order.unit_type
      end
      unit.province = order.destination_province
      unit.coast = order.destination_coast || ''
    end
  end

  def resolve_orders(orders)
    orders = parse_orders(orders)

    unit_movements = {}
    orders_by_current_province = {}
    orders.each do |power, orders_for_power|
      orders_for_power.each do |order|
        order.power = power
        # ensure orders refer to valid units
        next if order.failed?
        unit = @units[power].detect do |unit|
          unit.type == order.unit_type &&
          unit.province == order.current_province &&
          @provinces.has_key?(order.current_province.abbreviation)
        end

        if unit
          if order.move?
            # ensure moves are between neighboring provinces
            order.fail! unless order.current_province.has_neighbor?(order.destination_province.abbreviation)

            # ensure unit type is allowed to move on this type of province
            order.fail! if order.destination_province.type == 'water' && unit.army?
            order.fail! if order.destination_province.type == 'inland' && unit.fleet?

            # fail order if unit is a fleet and destination has coasts but a coast is not specified
            order.fail! if unit.fleet? && order.destination_province.has_multiple_coasts? && !order.destination_coast
          end
        else
          order.fail!
        end

        orders_by_current_province[order.current_province.abbreviation] = order unless order.failed?

        # add to unit_movements array to resolve conflicting moves later
        if order.move? && !order.failed?
          source = order.current_province.abbreviation
          dest = order.destination_province.abbreviation
          unit_movements[source] = dest
        end
      end
    end

    # resolve remaining holds and moves in the order of their dependency
    unit_movements.each_strongly_connected_component do |dependent_moves|
      dependent_moves.each do |source|
        order = orders_by_current_province.fetch(source, nil)
        next if order.nil? || order.hold?
        source = order.current_province.abbreviation
        dest = order.destination_province.abbreviation rescue nil

        # fail if someone is holding on destination
        order.fail! if orders_by_current_province[dest] && orders_by_current_province[dest].hold?

        # fail if someone on destination failed to move away
        order.fail! if orders_by_current_province[dest] && orders_by_current_province[dest].failed?

        # fail if anyone else is trying to enter destination
        order.fail! if orders_by_current_province.select {|k, other_order|
          other_order != order && other_order.move? && other_order.destination_province.abbreviation == dest
        }.size > 0

        # fail if unit in destination is trying to enter source
        if orders_by_current_province[dest] &&
           orders_by_current_province[dest].move? &&
           orders_by_current_province[dest].destination_province.abbreviation == source
          order.fail!
        end

        execute_order(order) unless order.failed?
      end
    end

    # concatenate the results
    orders.collect do |power, orders_for_power|
      "#{power}: #{orders_for_power.join(', ')}"
    end.join("\n")
  end

  def parse_province(province_text)
    province_text.capitalize!
    province = provinces.detect do |key, val|
      val.name == province_text || val.abbreviation == province_text
    end
    province = province[1] if province
    province
  end

  def unit_report
    @units.collect do |power, units|
      "#{power}: #{units.join(', ')}"
    end.join("\n")
  end
end