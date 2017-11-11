class Api::NumCitationsByYearController < ApplicationController
  def index
    pipeline = []
    num_citations_by_year = {}

    pipeline << {
      '$match': {
        'title': {
          '$regex': /^#{title}$/i
        }
      }
    } unless title.nil?

    pipeline << {
      '$match': {
        'authors.name': {
          '$in': [/^#{author}$/i]
        }
      }
    } unless author.nil?

    pipeline << {
      '$group': {
        '_id': '$year',
        'num_citations': { '$sum': { '$size': '$inCitations' } }
      }
    }

    Publication.collection.aggregate(pipeline).each do |result|
      year = result['_id']&.to_s
      next if year.nil?
      num_citations_by_year[year] = result['num_citations']
    end

    json_response(num_citations_by_year)
  end

  private

  def title
    params[:title]&.downcase
  end

  def author
    params[:author]&.downcase
  end
end
