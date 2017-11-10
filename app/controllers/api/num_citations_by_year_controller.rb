class Api::NumCitationsByYearController < ApplicationController
  def index
    num_citations_by_year = {}

    Publication.where(query).each do |publication|
      year = publication.year
      num_citations_by_year[year] ||= 0
      num_citations_by_year[year] += publication.inCitations.size
    end

    json_response(num_citations_by_year)
  end

  private

  def query
    queries = []
    queries << "this.title.toLowerCase() == '#{title}'" unless title.nil?
    queries << "this.authors.map(a => a['name'].toLowerCase()).includes('#{author}')" unless author.nil?

    return 'true' if queries.empty?
    queries.join(' && ')
  end

  def title
    params[:title]&.downcase
  end

  def author
    params[:author]&.downcase
  end
end
