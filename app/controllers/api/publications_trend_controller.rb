class Api::PublicationsTrendController < ApplicationController
  # q3
  # ignore c - just set all to 0
  def index
    num_publications_by_year = {}
    json = []

    Publication.where("this.venue.toLowerCase() == '#{venue}'").each do |publication|
      year = publication.year
      if num_publications_by_year[year].nil?
        num_publications_by_year[year] = 1
      else
        num_publications_by_year[year] += 1
      end
    end

    publications = num_publications_by_year.sort_by { |year, num_publications| year }
    publications.each do |publication|
      json << { year: publication.first, num_publications: publication.last, c: 0 }
    end

    json_response(json)
  end

  private

  def venue
    params[:venue].downcase || 'icse'
  end
end
