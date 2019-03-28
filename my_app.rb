require 'rack'
require 'logger'

class MyApp
  def call env
    req = Rack::Request.new(env)
    logger = Logger.new(STDOUT)
    logger.level = Logger::WARN      
  
    root = File.expand_path(File.dirname(__FILE__)) + "/public"
    index_file = root + "/index.html"
    success_file = root + "/success.html"
    failed_file = root + "/failed.html"
    doesnotexist_file = root + "/doesnotexist.html"

    main_css = root + "/css/main.css"
    success_css = root + "/css/success.css"
    failed_css = root + "/css/failed.css"
    
    
    if req.get?
      # Does the requested file exist? If not return 404
      # e.g. /foo/bar.css -> C:\MyDir\public\foo\bar.css
      file = root + req.path

      # What is the extension of the file? 
      content = ""
      case File.extname(file)
      # * if .css, return Content-Type text/css
      when ".css"
        content = "text/css"
      # * if .html, return content-type text/html
      when ".html"
        content = "text/html"
      # * if .js, return content-type application/javascript
      when ".js"
        content = "application/javascript"
      # * if .png, return image contents and content-type image/png
      when ".png"
        content = "image/png"
      when ".jpg"
        content = "image/jpg"
      # * if other, use content-type text/plain
      else
        content = "text/plain"
      end
      if req.path == '/'
        [200, {"Content-type" => "text/html"}, File.read(index_file)]
      elsif File.exist?(file)
        [200, {"Content-type" => "#{content}"}, [File.read(file), req.path]] 
      else
        [404, {"Content-type" => "text/html"}, [File.read(doesnotexist_file)]]
      end    
      # Examples
      # browser requests /index.html, server sets content to text/html nd returns root + "/index.html" contents
   
      #return [200, {"Content-type" => "#{content}"}, [File.read(index_file), File.read(main_css)]] if req.path == "/"
      
    elsif req.post?
      if ((req.params["username"] == "aladdin") && (req.params["password"] == "letmein"))
        [200, {"Content-type" => "text/html"}, [File.read(success_file),File.read(success_css)]]  
      else
        [200, {"Content-type" => "text/html"}, [File.read(failed_file), File.read(failed_css)]]  
      end
    else
      [400, {"Content-type" => "text/plain"}, ["Sorry #{req.request_method}"]]
    end
  end
end
