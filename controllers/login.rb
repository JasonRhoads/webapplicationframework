class Login
  def login(request, directory, mime_types)
    database = {
      "aladdin" => "letmein",
      "jason" => "ohyeah",
      "max" => "cpts",
      "admin" => "password",
    }
    
    username = request.params["username"]
    password = request.params["password"]
    if ((database.key?(username)) && (password == database[username]))
      [200, {"Content-type" => "text/html", "class_name" => "Login", "method_name" => "login", "Set-Cookie" => "NomNom=Hello World"}, [File.read("#{directory}/success.html")]]  
    else
      [401, {"Content-type" => "text/html", "class_name" => "Login", "method_name" => "login"}, [File.read("#{directory}/failed.html")]]  
    end
  end
end