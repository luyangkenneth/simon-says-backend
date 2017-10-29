class Api::PublicationsController < ApplicationController
  # q2
  def index
    publications_by_num_citations = {}
    json = []

    Publication.where("this.venue.toLowerCase() == '#{venue}'").each do |publication|
      num_citations = publication.inCitations.size
      publications_by_num_citations[publication.title] = num_citations
    end

    top_publications = publications_by_num_citations.sort_by { |title, num_citations| -num_citations }.first(top)
    top_publications.each do |publication|
      json << { title: publication.first, num_citations: publication.last }
    end

    json_response(json.reverse)
  end

  private

  def top
    params[:top].to_i || 5
  end

  def venue
    params[:venue].downcase || 'arxiv'
  end
end
