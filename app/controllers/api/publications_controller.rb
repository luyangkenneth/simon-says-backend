class Api::PublicationsController < ApplicationController
  def show
    publication = Publication.collection.find({ publication_id: publication_id }).first
    raise ArgumentError, "Could not find publication with id: #{publication_id}" if publication.nil?

    publication.delete(:_id)

    json_response(publication)
  end

  private

  def publication_id
    params[:id]
  end
end
