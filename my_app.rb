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
      "POST /login" => Proc.new{ |req, root, mime_types| post_request_dispatcher(req, root, mime_types) },
      "GET /me" => Proc.new{ |req, root, mime_types| get_request_dispatcher(req, root, mime_types) },
    }
    routes.default = Proc.new {|req, root, mime_types| request_dispatcher(req, root, mime_types)}

    wanted = "#{req.request_method} #{req.path.downcase}"
    routes[wanted].call(req, root, mime_types)
 
  end

  def request_dispatcher(req, root, mime_types)
      case req.request_method
      when "GET"
        get_request_dispatcher(req, root, mime_types)
      when "POST"
        post_request_dispatcher(req, root, mime_types)
      else
        [404, {"Content-type" => "text/html"}, [File.read("#{root}/doesnotexist.html")]]
      end
  end

  def get_request_dispatcher(req, root, mime_types)
    file = root + req.path
    file += "/index.html" if File.directory?(file)
    if File.exist?(file)
        [200, {"Content-type" => "#{mime_types[File.extname(file)]}"}, [File.read(file, mode: "rb")]] 
      #elsif req.path == "/loogin" || req.path == "/loggin" || req.path == "/lgin"
      #  [301, {"Location" => "/index.html"},[]]
    else
        [404, {"Content-type" => "text/html"}, [File.read("#{root}/doesnotexist.html")]]
    end
  end

  def post_request_dispatcher(req, root, mime_types)
    username = req.params["username"]
    password = req.params["password"]
    if ((username == "aladdin") && (password == "letmein"))
      [200, {"Content-type" => "text/html"}, [File.read("#{root}/success.html")]]  
    else
      [200, {"Content-type" => "text/html"}, [File.read("#{root}/failed.html")]]  
    end
  end

end
