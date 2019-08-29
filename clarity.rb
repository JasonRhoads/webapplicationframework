require "rack"
require "logger"

class Clarity
   def call env
    request = Rack::Request.new(env)
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::DEBUG
    
    directory = ENV['CLARITY_DIRECTORY'] ? ENV['CLARITY_DIRECTORY'] : File.expand_path(File.dirname(__FILE__)) + "/public"    
    file = directory + request.path
    file += "/index.html" if File.directory?(file)
    
    mime_types = get_mime_types(directory)
    content = mime_types[File.extname(file)]    
    routes = get_routes(directory)
            
    http_method_and_path = "#{request.request_method} #{request.path.downcase}"
    if routes.has_key? http_method_and_path
      dynamic_request_dispatcher(routes[http_method_and_path], request, directory, mime_types)
    else
      default_request_dispatcher(request, directory, mime_types)
    end
  end

  def dynamic_request_dispatcher(controller_file_name, request, directory, mime_types)
    *path_names, class_name, method_name = controller_file_name.scan(/(\w+\/|\w+)/).flatten
    file_name = [path_names, class_name, ".rb"].flatten.join
    class_name = class_name.split('_').map{|cn| cn.capitalize}.join
    if File.exist?("#{directory}/../controllers/#{file_name}") == false
      file_name = [path_names, class_name, ".rb"].flatten.join
    end
    load "#{directory}/../controllers/#{file_name}"
    instance = Object.const_get(class_name).new
    instance_method = instance.method(method_name)
    response = instance_method.call(request, directory, mime_types)
    @logger.debug %{class:#{class_name}, method:#{method_name}, status code:#{response[0]}}
    response
  end

  def default_request_dispatcher(request, directory, mime_types)
    file = directory + request.path
    file += "/index.html" if File.directory?(file)
    if File.exist?(file)
        [200, {"Content-type" => "#{mime_types[File.extname(file)]}"}, [File.read(file, mode: "rb")]] 
    else
        [404, {"Content-type" => "text/html"}, [File.read("#{directory}/doesnotexist.html")]]
    end
  end

  def get_routes(directory)
    routes = {}
    routes_file = File.open("#{directory}/../controllers/routes.txt")
    routes_file.each do |line|
      http_method_and_path, callback = line.scan(/(\w+\s+(?:\/\s|\/\w+)+)\s*(\w+#\w+)/)
        .flatten
      routes[http_method_and_path] = callback
    end
    routes
  end

  def get_mime_types(directory)
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


