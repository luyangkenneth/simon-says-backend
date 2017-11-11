class Api::TopAuthorsByNumPublicationsController < ApplicationController
  def index
    pipeline = []
    top_authors_by_num_publications = {}

    raise ArgumentError, 'Must specify either `top` or `venue` because number of authors is over 9000' if top.nil? && venue.nil?

    pipeline << {
      '$match': {
        'venue': {
          '$regex': /^#{venue}$/i
        }
      }
    } unless venue.nil?

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
end
