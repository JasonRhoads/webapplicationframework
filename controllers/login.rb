require_relative '..\cookie'

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

    $cookie["Name"] = username
    $cookie["NomNom"] = "Choco"
    $cookie.max_age = 100000
    
    if ((database.key?(username)) && (password == database[username]))
      [200, {"Content-type" => "text/html", "class_name" => "Login", "method_name" => "login"}, [File.read("#{directory}/success.html")]]  
    else  #'_clarity_session={"NomNom": "Hello World", "YumYum": "cookie2"}; Max-Age=100000; Path=\/me;'
      [401, {"Content-type" => "text/html", "class_name" => "Login", "method_name" => "login"}, [File.read("#{directory}/failed.html")]]  
    end
  end
end