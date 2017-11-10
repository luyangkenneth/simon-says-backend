class Api::TopAuthorsByNumPublicationsController < ApplicationController
  def index
    authors_by_num_publications = {}
    top_authors_by_num_publications = {}

    raise ArgumentError, 'Must specify either `top` or `venue` because number of authors is over 9000' if top.nil? && venue.nil?

    Publication.where(query).each do |publication|
      publication.authors.each do |author|
        name = author['name']
        authors_by_num_publications[name] ||= 0
        authors_by_num_publications[name] += 1
      end
    end

    top_authors = authors_by_num_publications.sort_by { |_name, num_publications| -num_publications }
    top_authors = top_authors.first(top) unless top.nil?
    top_authors.each do |author|
      top_authors_by_num_publications[author.first] = author.last
    end

    json_response(top_authors_by_num_publications)
  end

  private

  def query
    queries = []
    queries << "this.venue.toLowerCase() == '#{venue}'" unless venue.nil?

    return 'true' if queries.empty?
    queries.join(' && ')
  end

  def top
    params[:top]&.to_i
  end

  def venue
    params[:venue]&.downcase
  end
end
