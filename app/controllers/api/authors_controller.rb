class Api::AuthorsController < ApplicationController
  def index
    authors = Set.new

    Publication.all.each do |publication|
      authors += publication.authors.map { |author| author['name'] }.reject(&:blank?)
    end

    json_response(authors)
  end
end
