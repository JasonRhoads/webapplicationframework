require "rack"
require "logger"

class Clarity
   def call env
    request = Rack::Request.new(env)
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::DEBUG
    
    root = ENV['CLARITY_ROOT'] ? ENV['CLARITY_ROOT'] : File.expand_path(File.dirname(__FILE__)) + "/public"    
    file = root + request.path
    file += "/index.html" if File.directory?(file)
    
    mime_types = get_mime_types(root)
    content = mime_types[File.extname(file)]    
    routes = get_routes(root)
            
    wanted = "#{request.request_method} #{request.path.downcase}"
    if routes.has_key? wanted
      dynamic_request_dispatcher(routes[wanted], request, root, mime_types)
    else
      default_request_dispatcher(request, root, mime_types)
    end
  end

  def dynamic_request_dispatcher(controller_file_name, request, root, mime_types)
    *path_names, class_name, method_name = controller_file_name.scan(/(\w+\/|\w+)/).flatten
    file_name = [path_names, class_name, ".rb"].flatten.join #if not found search camel file name
    class_name = class_name.split('_').map{|cn| cn.capitalize}.join
    load "#{root}/../controllers/#{file_name}"
    instance = Object.const_get(class_name).new
    instance_method = instance.method(method_name)
    response = instance_method.call(request, root, mime_types)
    @logger.debug %{class:#{class_name}, method:#{method_name}, status code:#{response[0]}}
    response
  end

  def default_request_dispatcher(request, root, mime_types)
    file = root + request.path
    file += "/index.html" if File.directory?(file)
    if File.exist?(file)
        [200, {"Content-type" => "#{mime_types[File.extname(file)]}"}, [File.read(file, mode: "rb")]] 
    else
        [404, {"Content-type" => "text/html"}, [File.read("#{root}/doesnotexist.html")]]
    end
  end

  def get_routes(root)
    routes = {}
    routes_file = File.open("#{root}/../controllers/routes.txt")
    routes_file.each {|line| key, value = line.scan(/(\w*\s*[\/\w*]*)\s(\w*#\w*)/).flatten 
                      routes[key]= value}
    routes
  end

  def get_mime_types(root)
    mime_types = {}
    mime_types.default = "text/plain"
    mime_types_file = File.open("#{root}/../mime_types.txt")
    mime_types_file.each {|line| value, key = line.scan(/(\w*\/\w*):\s*([\W\w*]*)\b/).flatten
                          key = key.split(" ")
                          key.each{|i| mime_types[i] = value}}
    mime_types
  end

end


