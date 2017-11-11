class Api::TopPublicationsByNumCitationsController < ApplicationController
  def index
    pipeline = []
    top_publications_by_num_citations = {}

    raise ArgumentError, 'Must specify either `top` or `venue` because number of publications is over 9000' if top.nil? && venue.nil?

    pipeline << {
      '$project': {
        '_id': '$publication_id',
        'title': 1,
        'venue': 1,
        'num_citations': { '$sum': { '$size': '$inCitations' } }
      }
    }

    pipeline << {
      '$match': {
        'venue': {
          '$regex': /^#{venue}$/i
        }
      }
    } unless venue.nil?

    pipeline << {
      '$sort': {
        'num_citations': -1
      }
    }

    pipeline << {
      '$limit': top
    } unless top.nil?

    Publication.collection.aggregate(pipeline).each do |result|
      publication_id = result['_id']
      next if publication_id.nil?
      top_publications_by_num_citations[publication_id] = {
        title: result['title'],
        count: result['num_citations']
      }
    end

    json_response(top_publications_by_num_citations)
  end

  private

  def top
    params[:top]&.to_i
  end

  def venue
    params[:venue]&.downcase
  end
end
