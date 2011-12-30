class Province
  def initialize(attributes)
    @name = attributes['full name']
    @abbreviation = attributes['province']
    @neighbor_abbreviations = attributes['neighbors'].split(',')
  end
end