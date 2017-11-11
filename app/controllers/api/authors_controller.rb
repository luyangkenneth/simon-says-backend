class Api::AuthorsController < ApplicationController
  def index
    authors = Set.new

    Publication.collection.aggregate([
      { '$unwind': '$authors' },
      { '$group': { '_id': '$authors.name' } }
    ]).each do |publication|
      authors << publication['_id'] unless publication['_id'].blank?
    end

    json_response(authors)
  end
end
