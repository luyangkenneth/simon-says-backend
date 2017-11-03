class JsonImporter
  DEFAULT_RAW_JSON_FILE_PATH = "#{Rails.root}/../output.json"

  def self.import(input_file = DEFAULT_RAW_JSON_FILE_PATH)
    # Reset DB
    Publication.delete_all
    Publication.remove_indexes

    File.foreach(input_file).with_index(1) do |input_line, index|
      # Parse and sanitize json
      paper = JSON.parse(input_line)
      paper['authors'].map! do |author_hash|
        {
          'id'   => author_hash['ids'].first,
          'name' => author_hash['name']
        }
      end

      # Create publication
      Publication.create(
        authors:        paper['authors'],
        inCitations:    paper['inCitations'],
        outCitations:   paper['outCitations'],

        publication_id: paper['id'],
        title:          paper['title'],
        year:           paper['year'],
        venue:          paper['venue']
      )

      puts "Parsed #{index} papers" if index % 1000 == 0
    end

    Publication.create_indexes
  end
end
