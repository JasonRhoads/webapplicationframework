require 'rack'
require 'logger'

class MyApp
  def call env
    req = Rack::Request.new(env)
    logger = Logger.new(STDOUT)
    logger.level = Logger::WARN 
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
        
    file = root + req.path
    file += "/index.html" if File.directory?(file)
    content = mime_types[File.extname(file)]
    
    routes = {
      "POST /login" => "login#login",
      "GET /me" => "me_test#me",
    }
    
    wanted = "#{req.request_method} #{req.path.downcase}"
    if routes.has_key? wanted
      dynamic_request_dispatcher(routes[wanted], req, root, mime_types)
    else
      get_request_dispatcher(req, root, mime_types)
    end
  end

  def dynamic_request_dispatcher(controller_file_name, req, root, mime_types)
    klass = controller_file_name.gsub(/[A-Za-z0-9]*\//, "").sub(/#[A-Za-z0-9]*/, "").split('_').map{|e| e.capitalize}.join
    file_name = controller_file_name.sub(/#[A-Za-z0-9]*/, "") + ".rb"
    meth = controller_file_name.gsub(/[A-Za-z0-9]*\//, "").gsub(/[A-Za-z0-9]*_/, "").gsub(/[A-Za-z0-9]*#/, "")
    load "#{root}/../controllers/#{file_name}"
    instance = Object.const_get(klass).new
    execute = instance.method(meth)
    execute.call(req, root, mime_types)
  end

  def get_request_dispatcher(req, root, mime_types)
    file = root + req.path
    file += "/index.html" if File.directory?(file)
    if File.exist?(file)
        [200, {"Content-type" => "#{mime_types[File.extname(file)]}"}, [File.read(file, mode: "rb")]] 
    else
        [404, {"Content-type" => "text/html"}, [File.read("#{root}/doesnotexist.html")]]
    end
  end

end
