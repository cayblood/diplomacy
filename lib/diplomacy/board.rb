class Board
  def initialize(state_text)
    @units = {}
    state_text.lines.each do |line|
      power, units = line.split(':')
      @units[power] = units.strip.split(',').collect {|unit_text| Unit.new(unit_text) }
    end
  end

  def parse_orders(orders)
    returnval = {}
    orders.lines.collect do |order_line|
      power, orders_for_power = order_line.split(':')
      returnval[power] = orders_for_power.split(',').collect {|order| Order.new(order) }
    end
    returnval
  end

  def resolve_orders(orders)
    orders = parse_orders(orders)

    # ensure orders refer to valid units
    orders.each do |power, orders_for_power|
      orders_for_power.each do |order|
        order.fail! unless @units[power].detect {|unit| unit.type == order.unit_type && unit.province == order.current_province }
      end
    end

    # concatenate the results
    orders.collect do |power, orders_for_power|
      "#{power}: #{orders_for_power.join}"
    end.join
  end

  def unit_report
    "Austria: A Vie"
  end
end