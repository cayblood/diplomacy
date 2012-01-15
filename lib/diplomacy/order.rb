class Order
  attr_accessor :unit_type, :current_province, :destination_province, :failed

  def initialize(order_line, board)
    @order_line = order_line.strip
    @failed = false

    # determine order type
    matchdata = @order_line.match(/^(A|F) (\w+)(?: |-)(\w+)$/i)
    if matchdata
      @unit_type = $1.upcase
      @current_province = board.parse_province($2)
      @failed = true if @current_province.nil?
      unless $3.capitalize == 'Holds'
        @destination_province = board.parse_province($3)
        @failed = true if @destination_province.nil?
      end
    else
      @failed = true
    end
  end

  def hold?
    @destination_province.nil?
  end

  def move?
    !@destination_province.nil?
  end

  def fail!
    @failed = true
  end

  def failed?
    @failed
  end

  def to_s
    if @failed
      '_' + @order_line.gsub(' ', '_') + '_'
    else
      @order_line
    end
  end
end