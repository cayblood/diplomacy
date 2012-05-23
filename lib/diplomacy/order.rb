class Order
  attr_accessor :unit_type, :current_province, :destination_province, :destination_coast, :failed, :power

  def initialize(order_line, board)
    @order_line = order_line.strip
    @failed = false

    # determine order type
    unit_regex = /(A|F)\s+(\w+)/
    hold_move_regex = /^#{unit_regex}(?:\s+|-)(\w+)(?:\s+([NSEW]C))?$/i
    support_regex = /^#{unit_regex}\s+S\s+#{unit_regex}((?:\s+|-)(\w+)(?:\s+([NSEW]C))?)?$/i

    matchdata = @order_line.match(hold_move_regex)
    if matchdata
      @unit_type = $1.upcase
      @current_province = board.parse_province($2)
      @failed = true unless @current_province
      unless $3.capitalize == 'Holds'
        @destination_province = board.parse_province($3)
        @failed = true if @destination_province.nil?
      end
      @destination_coast = $4.upcase if $4
    else
      matchdata = @order_line.match(support_regex)
      if matchdata
        @unit_type = $1.upcase
        @current_province = board.parse_province($2)
        @failed = true unless @current_province
        @supported_unit_type = $3.upcase
        @supported_unit_current_province = $4.capitalize
        @failed = true unless @supported_unit_current_province
        unless $5.capitalize == 'Holds'
          @supported_unit_destination_province = board.parse_province($5)

        end
      else
        @failed = true
      end
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