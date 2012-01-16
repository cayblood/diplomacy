class Province
  attr_accessor :name, :abbreviation, :neighbor_abbreviations
  def initialize(attributes)
    @name = attributes['full name']
    @abbreviation = attributes['province']
    @neighbor_abbreviations = attributes['neighbors'].split(',')
  end

  def ==(other_province)
    return false if other_province.nil?
    @name == other_province.name
  end

  def has_neighbor?(neighbor)
    @neighbor_abbreviations.include?(neighbor)
  end
end