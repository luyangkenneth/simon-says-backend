class Api::WordCloudController < ApplicationController
  # q5
  def index
    json = {
      title: 'hello',
      message: 'world'
    }

    json_response(json)
  end
end
