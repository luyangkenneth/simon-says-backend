class Publication
  include Mongoid::Document

  field :authors,        type: Array
  field :inCitations,    type: Array
  field :outCitations,   type: Array

  field :publication_id, type: String
  field :title,          type: String
  field :year,           type: Integer
  field :venue,          type: String

  index({ publication_id: 1 }, { unique: true })
end
