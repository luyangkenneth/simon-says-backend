class Api::NumPublicationsByYearController < ApplicationController
  def index
    num_publications_by_year = {}

    Publication.where(query).each do |publication|
      year = publication.year
      num_publications_by_year[year] ||= 0
      num_publications_by_year[year] += 1
    end

    json_response(num_publications_by_year)
  end

  private

  def query
    queries = []
    queries << "this.venue.toLowerCase() == '#{venue}'" unless venue.nil?
    queries << "this.authors.map(a => a['name'].toLowerCase()).includes('#{author}')" unless author.nil?
    raise ArgumentError, 'No params specified' if queries.empty?
    queries.join(' && ')
  end

  def venue
    params[:venue]&.downcase
  end

  def author
    params[:author]&.downcase
  end
end
