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

  def resolve_orders(orders)
    orders = parse_orders(orders)

    orders.each do |power, orders_for_power|
      orders_for_power.each do |order|
        # ensure orders refer to valid units
        next if order.failed?
        order.fail! unless @units[power].detect do |unit|
          unit.type == order.unit_type &&
          unit.province == order.current_province &&
          @provinces.has_key?(order.current_province.abbreviation)
        end

        # ensure moves are between neighboring provinces
        order.fail! unless order.current_province.has_neighbor?(order.destination_province.abbreviation) if order.move?

        # carry out order if successful
        if order.move? && !order.failed?
          unit = units[power].detect {|u| u.province == order.current_province }
          unit.province = order.destination_province
        end
      end
    end

    # concatenate the results
    orders.collect do |power, orders_for_power|
      "#{power}: #{orders_for_power.join}"
    end.join
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
    end.join
  end
end