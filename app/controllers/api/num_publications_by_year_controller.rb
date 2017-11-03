class Api::NumPublicationsByYearController < ApplicationController
  def index
    num_publications_by_year = {}

    Publication.where("this.venue.toLowerCase() == '#{venue}'").each do |publication|
      year = publication.year
      if num_publications_by_year[year].nil?
        num_publications_by_year[year] = 1
      else
        num_publications_by_year[year] += 1
      end
    end

    json_response(num_publications_by_year)
  end

  private

  def venue
    params[:venue].downcase
  end
end
