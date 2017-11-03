class Api::WordCloudController < ApplicationController
  def index
    json = {
      title: 'hello',
      total_num_publications: Publication.count
    }

    json_response(json)
  end
end
