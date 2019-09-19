class MimeTypes
  def initialize(app_root)
    @mime_types = {}
    @mime_types.default = "text/plain"
    @mime_types_file = File.open("#{app_root}/../mime_types.txt")
    @mime_types_file.each do |line| 
      content, file_extension = line.scan(/([a-z]+\/[a-z]+):\s+((?:\.[a-z]+\s+|\.[a-z]+)+)\b/)
        .flatten
      file_extension = file_extension.split(" ")
      file_extension.each{|i| @mime_types[i] = content}
    end
  end

  def [](file_extension)
    @mime_types[file_extension]
  end
end