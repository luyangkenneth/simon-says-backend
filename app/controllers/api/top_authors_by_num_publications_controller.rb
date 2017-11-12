class Api::TopAuthorsByNumPublicationsController < ApplicationController
  def index
    pipeline = []
    top_authors_by_num_publications = {}

    raise ArgumentError, 'Must specify `top`' if top.nil?

    pipeline << {
      '$match': {
        'venue': {
          '$regex': /^#{Regexp.escape(venue)}$/i
        }
      }
    } unless venue.nil?

    pipeline << {
      '$match': {
        'year': {
          '$gte': start_year
        }
      }
    } unless start_year.nil?

    pipeline << {
      '$match': {
        'year': {
          '$lte': end_year
        }
      }
    } unless end_year.nil?

    pipeline += [
      { '$unwind': '$authors' },

      {
        '$group': {
          '_id': '$authors.name',
          'num_publications': { '$sum': 1 }
        }
      },

      {
        '$sort': {
          'num_publications': -1,
          '_id': 1
        }
      }
    ]

    pipeline << {
      '$limit': top
    } unless top.nil?

    Publication.collection.aggregate(pipeline).each do |result|
      author = result['_id']
      next if author.nil?
      top_authors_by_num_publications[author] = result['num_publications']
    end

    json_response(top_authors_by_num_publications)
  end

  private

  def top
    params[:top]&.to_i
  end

  def venue
    params[:venue]&.downcase
  end

  def start_year
    params[:start_year]&.to_i
  end

  def end_year
    params[:end_year]&.to_i
  end
end
