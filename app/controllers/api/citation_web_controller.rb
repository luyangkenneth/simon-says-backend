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

    # Level 1
    level_one_incitations = []
    Publication.collection.aggregate([
      {
        '$match': {
          'publication_id': {
            '$in': base_paper['inCitations']
          }
        }
      }
    ]).each do |paper|
      citation_web[paper['publication_id']] = {
        title: paper['title'],
        inCitations: paper['inCitations']
      }
      level_one_incitations += paper['inCitations']
    end

    # Level 2
    Publication.collection.aggregate([
      {
        '$match': {
          'publication_id': {
            '$in': level_one_incitations
          }
        }
      }
    ]).each do |paper|
      citation_web[paper['publication_id']] = {
        title: paper['title'],
        inCitations: paper['inCitations']
      }
    end

    json_response(citation_web)
  end

  private

  def title
    params[:title]&.downcase
  end
end
