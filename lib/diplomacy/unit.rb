class Unit
  attr_accessor :type, :province, :coast
  def initialize(unit_text, board)
    @type, province_text, coast_text = unit_text.strip.split
    @type.upcase!
    @province = board.parse_province(province_text)
    @coast = coast_text ? coast_text : ''
  end

  def to_s
    "#{@type} #{@province.abbreviation} #{@coast}".strip
  end

  def fleet?
    @type == 'F'
  end

  def army?
    @type == 'A'
  end

  def can_move_to?(province)
    # ensure moves are between neighboring provinces
    returnval = true
    returnval = false unless @province.has_neighbor?(province.abbreviation)
    returnval = false if province.type == 'water' && army?
    returnval = false if province.type == 'inland' && fleet?
    returnval
  end
end