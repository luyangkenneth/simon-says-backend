class Api::WordCloudController < ApplicationController
  def index
    pipeline = []
    word_cloud = {}

    pipeline << {
      '$match': {
        'authors.name': {
          '$in': [/^#{Regexp.escape(author)}$/i]
        }
      }
    } unless author.nil?

    pipeline += [
      { '$unwind': '$keyPhrases' },

      {
        '$group': {
          '_id': '$keyPhrases',
          'count': { '$sum': 1 }
        }
      },

      {
        '$sort': {
          'count': -1,
          '_id': 1
        }
      },

      { '$limit': 100 },
    ]

    Publication.collection.aggregate(pipeline).each do |result|
      phrase = result['_id']
      next if phrase.nil?
      word_cloud[phrase] = result['count']
    end

    json_response(word_cloud)
  end

  private

  def author
    params[:author]&.downcase
  end
end
