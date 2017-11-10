class Publication
  include Mongoid::Document

  field :authors,        type: Array
  field :inCitations,    type: Array
  field :outCitations,   type: Array

  field :publication_id, type: String
  field :title,          type: String
  field :year,           type: Integer
  field :venue,          type: String

  field :keyPhrases,     type: Array
  field :paperAbstract,  type: String
  field :pdfUrls,        type: Array
  field :s2Url,          type: String

  index({ publication_id: 1 }, { unique: true })
  index({ title: 1 })
end
