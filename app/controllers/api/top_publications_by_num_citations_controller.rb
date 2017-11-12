class Api::TopPublicationsByNumCitationsController < ApplicationController
  def index
    pipeline = []
    top_publications_by_num_citations = {}

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
      {
        '$project': {
          '_id': '$publication_id',
          'title': 1,
          'num_citations': { '$sum': { '$size': '$inCitations' } }
        }
      },

      {
        '$sort': {
          'num_citations': -1,
        }
      }
    ]

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

  def start_year
    params[:start_year]&.to_i
  end

  def end_year
    params[:end_year]&.to_i
  end
end
