class Api::PublicationTitlesController < ApplicationController
  def index
    publication_titles = Set.new

    Publication.collection.aggregate([
      { '$project': { 'title': 1 } }
    ]).each do |publication|
      publication_titles << publication['title'] unless publication['title'].blank?
    end

    json_response(publication_titles)
  end
end
