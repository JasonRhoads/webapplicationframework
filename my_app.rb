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
    success_file = root + "/success.html"
    failed_file = root + "/failed.html"
    doesnotexist_file = root + "/doesnotexist.html"
    
    if req.get?
      file = root + req.path
      file += "/index.html" if File.directory?(file)
      content = mime_types[File.extname(file)]
     
      if File.exist?(file)
        [200, {"Content-type" => "#{content}"}, [File.read(file, mode: "rb")]] 
      elsif req.path == "/loogin" || req.path == "/loggin" || req.path == "/lgin"
        [301, {"Location" => "/index.html"},[]]
      else
        [404, {"Content-type" => "text/html"}, [File.read(doesnotexist_file)]]
      end

    elsif req.post? && req.path =="/login"
      if ((req.params["username"] == "aladdin") && (req.params["password"] == "letmein"))
        [200, {"Content-type" => "text/html"}, [File.read(success_file)]]  
      else
        [200, {"Content-type" => "text/html"}, [File.read(failed_file)]]  
      end
    else
      [400, {"Content-type" => "text/plain"}, ["Sorry #{req.request_method}"]]
    end
   
  end

  def get_request_dispatcher(file, content)
      if File.exist?(@file)
        [200, {"Content-type" => "#{content}"}, [File.read(file, mode: "rb")]] 
      elsif req.path == "/loogin" || req.path == "/loggin" || req.path == "/lgin"
        [301, {"Location" => "/index.html"},[]]
      else
        [404, {"Content-type" => "text/html"}, [File.read(doesnotexist_file)]]
      end
    end
end
