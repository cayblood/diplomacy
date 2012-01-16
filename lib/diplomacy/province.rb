class Province
  attr_accessor :name, :abbreviation, :type, :neighbor_abbreviations, :coasts
  def initialize(attributes)
    @name = attributes['full name']
    @abbreviation = attributes['province']
    @type = attributes['type']
    @neighbor_abbreviations = attributes.fetch('neighbors', '').split(',')
    @coasts = attributes.fetch('coasts', '').split(',')
    @coastal_neighbors = {}
    attributes.fetch('coastal neighbors', '').split(',').each do |coastal_neighbor|
      coast, province_text = coastal_neighbor.split('-')
      coast.strip!
      province_text.strip!
      @coastal_neighbors[coast] ||= ''
      @coastal_neighbors[coast] = (@coastal_neighbors[coast].split(',') << province_text.capitalize).join(',')
    end
  end

  def ==(other_province)
    return false if other_province.nil?
    @name == other_province.name
  end

  def has_neighbor?(neighbor_abbreviation, from_coast = nil)
    if from_coast
      @coastal_neighbors[from_coast].include?(neighbor_abbreviation)
    else
      @neighbor_abbreviations.include?(neighbor_abbreviation)
    end
  end

  def has_multiple_coasts?
    @coasts.size > 1
  end
end