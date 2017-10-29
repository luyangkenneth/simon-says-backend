class Api::CitationWebController < ApplicationController
  # q4
  # put all the relevant info about the papers in "nodes"
  def index
    json = {
      nodes: [],
      links: []
    }

    # Level 0
    base_paper = Publication.find_by("this.title.toLowerCase() == '#{title}'")
    json[:nodes] << generate_node_json(0, 0, base_paper)

    # Level 1
    nodes_1 = {}
    papers_1 = []
    base_paper.inCitations.each do |publication_id_1|
      paper_1 = Publication.find_by(publication_id: publication_id_1)
      next if paper_1.nil?

      index_1 = next_node_index
      json[:nodes] << generate_node_json(1, index_1, paper_1)
      json[:links] << { source: index_1, target: 0 }

      nodes_1[publication_id_1] = index_1
      papers_1 << paper_1
    end

    # Level 2
    papers_1.each do |paper_1|
      index_1 = nodes_1[paper_1.publication_id]
      paper_1.inCitations.each do |publication_id_2|
        if nodes_1[publication_id_2].nil?
          # Create new node
          paper_2 = Publication.find_by(publication_id: publication_id_2)
          next if paper_2.nil?

          index_2 = next_node_index
          json[:nodes] << generate_node_json(2, index_2, paper_2)
          json[:links] << { source: index_2, target: index_1 }
        else
          # Link existing node
          json[:links] << { source: nodes_1[publication_id_2], target: index_1 }
        end
      end
    end

    json_response(json)
  end

  private

  def title
    params[:title].downcase || 'Low-density parity check codes over GF(q)'.downcase
  end

  def next_node_index
    if @next_node_index.nil?
      @next_node_index = 0
    else
      @next_node_index += 1
    end
  end

  def generate_node_json(level, index, paper)
    {
      level:   level,
      index:   index,

      title:   paper.title,
      year:    paper.year.to_s,
      venue:   paper.venue,
      authors: paper.authors.map { |author| author['name'] }
                            .reduce { |concat, name| "#{concat}, #{name}" }
    }
  end

end
