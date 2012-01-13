class Unit
  attr_accessor :type, :province
  def initialize(unit_text)
    @type, @province = unit_text.split
    @type.upcase!
    @province.capitalize!
  end
end