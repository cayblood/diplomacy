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

  def move_unit(power, current_province, destination_province, coast = '')
    unit = units[power].detect {|u| u.province == current_province }
    unit.province = destination_province
    unit.coast = coast || ''
  end

  def resolve_orders(orders)
    orders = parse_orders(orders)

    moves = Hash.new {|h, k| h[k] = [] }
    orders.each do |power, orders_for_power|
      orders_for_power.each do |order|
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

        # add to moves array to resolve conflicting moves later
        if order.move? && !order.failed?
          moves[order.destination_province] << [
            order,
            power,
            order.current_province,
            order.destination_province,
            order.destination_coast
          ]
        end
      end
    end

    # resolve moves
    moves.each do |destination, moves|
      if moves.size == 1
        move = moves.first
        order = move.shift
        move_unit(*move)
      else # conflicts
        moves.each {|order, moves| order.fail! }
      end
    end

    # concatenate the results
    orders.collect do |power, orders_for_power|
      "#{power}: #{orders_for_power.join}"
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
      "#{power}: #{units.join(',')}"
    end.join("\n")
  end
end