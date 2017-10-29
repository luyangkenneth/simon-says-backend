class Api::AuthorsController < ApplicationController
  # q1
  def index
    authors_by_num_publications = {}
    json = []

    Publication.where("this.venue.toLowerCase() == '#{venue}'").each do |publication|
      publication.authors.each do |author|
        name = author['name']
        if authors_by_num_publications[name].nil?
          authors_by_num_publications[name] = 1
        else
          authors_by_num_publications[name] += 1
        end
      end
    end

    top_authors = authors_by_num_publications.sort_by { |name, num_publications| -num_publications }.first(top)
    top_authors.each do |author|
      json << { author: author.first, num_publications: author.last }
    end

    json_response(json.reverse)
  end

  private

  def top
    params[:top].to_i || 10
  end

  def venue
    params[:venue].downcase || 'arxiv'
  end
end
