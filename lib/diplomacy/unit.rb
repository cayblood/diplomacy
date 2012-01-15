class Unit
  attr_accessor :type, :province
  def initialize(unit_text, board)
    @type, province_text = unit_text.split
    @type.upcase!
    @province = board.parse_province(province_text)
  end

  def to_s
    "#{@type} #{@province.abbreviation}"
  end
end