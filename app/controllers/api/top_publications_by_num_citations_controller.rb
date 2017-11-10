class Api::TopPublicationsByNumCitationsController < ApplicationController
  def index
    publications_by_num_citations = {}
    top_publications_by_num_citations = {}

    raise ArgumentError, 'Must specify either `top` or `venue` because number of publications is over 9000' if top.nil? && venue.nil?

    Publication.where(query).each do |publication|
      publications_by_num_citations[publication.publication_id] = {
        title: publication.title,
        num_citations: publication.inCitations.size
      }
    end

    top_publications = publications_by_num_citations.sort_by { |_publication_id, publication| -publication[:num_citations] }
    top_publications = top_publications.first(top) unless top.nil?
    top_publications.each do |publication|
      top_publications_by_num_citations[publication.first] = {
        title: publication.last[:title],
        count: publication.last[:num_citations]
      }
    end

    json_response(top_publications_by_num_citations)
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
