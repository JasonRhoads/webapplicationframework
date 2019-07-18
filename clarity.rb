require "rack"
require "logger"

class Clarity
   def call env
    request = Rack::Request.new(env)
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::DEBUG
    
    mime_types = {
      ".css"  => "text/css",
      ".html" => "text/html",
      ".js"   => "application/javascript",
      ".png"  => "image/png",
      ".jpg"  => "image/jpeg",
      ".jpeg" => "image/jpeg",
    }
    mime_types.default = "text/plain"
  
    root = File.expand_path(File.dirname(__FILE__)) + "/public"
        
    file = root + request.path
    file += "/index.html" if File.directory?(file)
    content = mime_types[File.extname(file)]
    
    routes = {
      "POST /login" => "login#login",
      "GET /me" => "me_test#me",
    }
    
    wanted = "#{request.request_method} #{request.path.downcase}"
    if routes.has_key? wanted
      dynamic_request_dispatcher(routes[wanted], request, root, mime_types)
    else
      get_request_dispatcher(request, root, mime_types)
    end
  end

  def dynamic_request_dispatcher(controller_file_name, request, root, mime_types)
    *path_names, class_name, method_name = controller_file_name.scan(/(\w+\/|\w+)/).flatten
    file_name = [path_names, class_name, ".rb"].flatten.join
    class_name = class_name.split('_').map{|cn| cn.capitalize}.join
    load "#{root}/../controllers/#{file_name}"
    instance = Object.const_get(class_name).new
    instance_method = instance.method(method_name)
    response = instance_method.call(request, root, mime_types)
    @logger.debug %{class:#{class_name}, method:#{method_name}, status code:#{response[0]}}
    response
  end

  def get_request_dispatcher(request, root, mime_types)
    file = root + request.path
    file += "/index.html" if File.directory?(file)
    if File.exist?(file)
        [200, {"Content-type" => "#{mime_types[File.extname(file)]}"}, [File.read(file, mode: "rb")]] 
    else
        [404, {"Content-type" => "text/html"}, [File.read("#{root}/doesnotexist.html")]]
    end
  end

end


