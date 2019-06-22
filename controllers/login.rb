class Login
  def login(req, root, mime_types)
    database = {
      "aladdin" => "letmein",
      "jason" => "ohyeah",
      "max" => "cpts",
      "admin" => "password",
    }
    
    username = req.params["username"]
    password = req.params["password"]
    if ((database.key?(username)) && (password == database[username]))
      [200, {"Content-type" => "text/html"}, [File.read("#{root}/success.html")]]  
    else
      [200, {"Content-type" => "text/html"}, [File.read("#{root}/failed.html")]]  
    end
  end
end