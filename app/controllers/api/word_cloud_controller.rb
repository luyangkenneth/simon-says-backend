class Api::WordCloudController < ApplicationController
  # q5
  def index
    json = []

    Publication.where("this.venue.toLowerCase() == '#{venue}'").each do |publication|
      json << publication.title
    end

    json_response(json)
  end

  private

  def venue
    params[:venue].downcase || 'arxiv'
  end
end
