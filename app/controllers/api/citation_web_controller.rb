class Api::CitationWebController < ApplicationController
  def index
    citation_web = {}

    raise ArgumentError, 'Must specify `title` and `depth`' if title.nil? || depth.nil?
    raise ArgumentError, '`depth` must be an integer between 0 - 5' unless depth.in?(0..5)

    # Level 0
    base_paper = Publication.collection.find({ title: /^#{Regexp.escape(title)}$/i }).first
    raise ArgumentError, "Could not find base paper titled: #{title}" if base_paper.nil?

    citation_web[base_paper['publication_id']] = {
      title: base_paper['title'],
      inCitations: base_paper['inCitations']
    }

    # Level N
    previous_incitations = base_paper['inCitations']
    current_incitations = []

    depth.times do
      Publication.collection.aggregate([
        {
          '$match': {
            'publication_id': {
              '$in': previous_incitations
            }
          }
        }
      ]).each do |paper|
        citation_web[paper['publication_id']] = {
          title: paper['title'],
          inCitations: paper['inCitations']
        }

        current_incitations += paper['inCitations']
      end

      previous_incitations = current_incitations
    end

    json_response(citation_web)
  end

  private

  def title
    params[:title]&.downcase
  end

  def depth
    params[:depth]&.to_i
  end
end
