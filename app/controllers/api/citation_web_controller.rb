class Api::CitationWebController < ApplicationController
  def index
    citation_web = {}

    raise ArgumentError, 'Must specify `title`' if title.nil?

    # Level 0
    base_paper = Publication.collection.find({ title: /^#{Regexp.escape(title)}$/i }).first
    raise ArgumentError, "Could not find base paper titled: #{title}" if base_paper.nil?

    citation_web[base_paper['publication_id']] = {
      title: base_paper['title'],
      inCitations: base_paper['inCitations']
    }

    json_response(citation_web)
  end

  private

  def title
    params[:title]&.downcase
  end
end
