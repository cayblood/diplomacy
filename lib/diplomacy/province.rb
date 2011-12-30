class Province
  def initialize(attributes)
    @name = attributes['full name']
    @abbreviation = attributes['province']
    @neighbor_abbreviations = atributes['neighbors'].split(',')
  end
end