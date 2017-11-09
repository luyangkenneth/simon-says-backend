class ApplicationController < ActionController::API
  include Response

  rescue_from StandardError do |error|
    render json: { error: error.message }, status: :bad_request
  end
end
