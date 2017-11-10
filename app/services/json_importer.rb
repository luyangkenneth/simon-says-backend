class JsonImporter
  DEFAULT_RAW_JSON_FILE_PATH = "#{Rails.root}/output.json"

  def self.import(input_file = DEFAULT_RAW_JSON_FILE_PATH)
    # Reset DB
    Publication.delete_all
    Publication.remove_indexes
    Publication.create_indexes

    File.foreach(input_file).with_index(1) do |input_line, index|
      # Parse json
      paper = JSON.parse(input_line)

      # Create publication
      Publication.create(
        authors:        paper['authors'],
        inCitations:    paper['inCitations'],
        outCitations:   paper['outCitations'],

        publication_id: paper['id'],
        title:          paper['title'],
        year:           paper['year'],
        venue:          paper['venue'],

        keyPhrases:     paper['keyPhrases'],
        paperAbstract:  paper['paperAbstract'],
        pdfUrls:        paper['pdfUrls'],
        s2Url:          paper['s2Url']
      )

      puts "Parsed #{index} papers" if index % 1000 == 0
    end

    Publication.create_indexes
  end
end
