class Order
  attr_accessor :unit_type, :current_province
  def initialize(order_line)
    @order_line = order_line.strip
    @unit_type, @current_province = order_line.split
    @unit_type.upcase!
    @current_province.capitalize!
    @failed = false
  end

  def fail!
    @failed = true
  end

  def to_s
    if @failed
      '_' + @order_line.gsub(' ', '_') + '_'
    else
      @order_line
    end
  end
end