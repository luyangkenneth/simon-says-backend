class JsonExtractor
  def self.extract(input_file_path, output_file_path, num_lines = 200000)
    input_file = "#{Rails.root}/#{input_file_path}"
    output_file = "#{Rails.root}/#{output_file_path}"

    # This will overwrite the file
    File.new(output_file, 'w')

    File.foreach(input_file).with_index(1) do |line, line_no|
      break if line_no > num_lines
      File.open(output_file, 'a') { |file| file.write(line + "\n") }
    end
  end
end
