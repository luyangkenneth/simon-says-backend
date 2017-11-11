class Api::NumPublicationsByYearController < ApplicationController
  def index
    pipeline = []
    num_publications_by_year = {}

    pipeline << {
      '$match': {
        'venue': {
          '$regex': /^#{Regexp.escape(venue)}$/i
        }
      }
    } unless venue.nil?

    pipeline << {
      '$match': {
        'authors.name': {
          '$in': [/^#{Regexp.escape(author)}$/i]
        }
      }
    } unless author.nil?

    pipeline << {
      '$group': {
        '_id': '$year',
        'num_publications': { '$sum': 1 }
      }
    }

    Publication.collection.aggregate(pipeline).each do |result|
      year = result['_id']&.to_s
      next if year.nil?
      num_publications_by_year[year] = result['num_publications']
    end

    json_response(num_publications_by_year)
  end

  private

  def venue
    params[:venue]&.downcase
  end

  def author
    params[:author]&.downcase
  end
end
