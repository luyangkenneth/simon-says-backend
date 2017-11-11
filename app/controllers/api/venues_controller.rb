class Api::VenuesController < ApplicationController
  def index
    venues = Set.new

    Publication.collection.aggregate([
      { '$project': { 'venue': 1 } }
    ]).each do |publication|
      venues << publication['venue'] unless publication['venue'].blank?
    end

    json_response(venues)
  end
end
