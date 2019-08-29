class DefaultRequestDispatcher
  def self.default_request_dispatcher(request, directory, mime_types)
    file = directory + request.path
    file += "/index.html" if File.directory?(file)
    if File.exist?(file)
        [200, {"Content-type" => "#{mime_types[File.extname(file)]}"}, [File.read(file, mode: "rb")]] 
    else
        [404, {"Content-type" => "text/html"}, [File.read("#{directory}/doesnotexist.html")]]
    end
  end
end