class Api::NumCitationsByYearController < ApplicationController
  def index
    pipeline = []
    num_citations_by_year = {}

    pipeline << {
      '$match': {
        'title': {
          '$regex': /^#{Regexp.escape(title)}$/i
        }
      }
    } unless title.nil?

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
        'num_citations': { '$sum': { '$size': '$inCitations' } }
      }
    }

    Publication.collection.aggregate(pipeline).each do |result|
      year = result['_id']&.to_s
      next if year.nil?
      num_citations_by_year[year] = result['num_citations']
    end

    (1990..2017).each do |year|
      num_citations_by_year[year.to_s] ||= 0
    end

    json_response(num_citations_by_year)
  end

  private

  def title
    params[:title]&.downcase
  end

  def venue
    params[:venue]&.downcase
  end

  def author
    params[:author]&.downcase
  end
end
