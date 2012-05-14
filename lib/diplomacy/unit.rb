class Unit
  attr_accessor :_type, :province, :coast
  def initialize(unit_text, board)
    @_type, province_text, coast_text = unit_text.strip.split
    @_type.upcase!
    @province = board.parse_province(province_text)
    @coast = coast_text ? coast_text : ''
  end

  def to_s
    "#{@_type} #{@province.abbreviation} #{@coast}".strip
  end

  def fleet?
    @_type == 'F'
  end

  def army?
    @_type == 'A'
  end
end