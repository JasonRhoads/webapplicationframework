require 'rack'

class MyApp
  def call env
    req = Rack::Request.new(env)
    root = File.expand_path(File.dirname(__FILE__))
    index_file = root + "/index.html"
    success_file = root + "/success.html"
    failed_file = root + "/failed.html"
    doesnotexist_file = root + "/doesnotexist.html"

    main_css = root + "/styles/main.css"
    success_css = root + "/styles/success.css"
    failed_css = root + "/styles/failed.css"
    
    
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
