class MimeTypes
  def self.get_mime_types(directory)
    mime_types = {}
    mime_types.default = "text/plain"
    mime_types_file = File.open("#{directory}/../mime_types.txt")
    mime_types_file.each do |line| 
      content, file_extension = line.scan(/([a-z]+\/[a-z]+):\s+((?:\.[a-z]+\s+|\.[a-z]+)+)\b/)
        .flatten
      file_extension = file_extension.split(" ")
      file_extension.each{|i| mime_types[i] = content}
    end
    mime_types
  end
end