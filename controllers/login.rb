class Login
  def login(request, root, mime_types)
    database = {
      "aladdin" => "letmein",
      "jason" => "ohyeah",
      "max" => "cpts",
      "admin" => "password",
    }
    
    username = request.params["username"]
    password = request.params["password"]
    if ((database.key?(username)) && (password == database[username]))
      [200, {"Content-type" => "text/html"}, [File.read("#{root}/success.html")]]  
    else
      [401, {"Content-type" => "text/html"}, [File.read("#{root}/failed.html")]]  
    end
  end
end