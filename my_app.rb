require 'rack'

class MyApp
  def call env
    req = Rack::Request.new(env)
    root = File.expand_path(File.dirname(__FILE__))
    index_file = root + "/public/index.html"
    success_file = root + "/public/success.html"
    failed_file = root + "/public/failed.html"
    doesnotexist_file = root + "/public/doesnotexist.html"

    main_css = root + "/public/css/main.css"
    success_css = root + "/public/css/success.css"
    failed_css = root + "/public/css/failed.css"
    
    
    if req.get?
      return [200, {"Content-type" => "text/html"}, [File.read(index_file), File.read(main_css)]] if req.path == "/"
      
      [404, {"Content-type" => "text/html"}, [File.read(doesnotexist_file)]]
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
