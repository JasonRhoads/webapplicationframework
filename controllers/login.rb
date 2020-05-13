require_relative '..\cookie'
require_relative '..\database'
require 'sequel'
require 'sqlite3'
require 'bcrypt'

class Login
  def login(request, directory, mime_types)
    db = Database.db_connect()

    password = db['select password from users where username = ?', request.params["username"]].first[:password]
    username = db['select username from users where username = ?', request.params["username"]].first[:username]

    $cookie["Name"] = username
    $cookie["NomNom"] = "Choco"
    $cookie.max_age = 1000000  
    $cookie["Id"] = db['SELECT id FROM users WHERE username = ?', username].first[:id]
    puts "login class"
    puts username
    puts password
    puts $cookie["Id"]
    puts $cookie
    
    hashed_password = BCrypt::Password.new(password)
        
    if ((username == request.params["username"]) && (hashed_password == request.params["password"]))
      load "#{directory}/../controllers/account.rb"
    instance = Object.const_get("Account").new
    instance_method = instance.method("account")

    response = instance_method.call(request, directory, mime_types)
    response[1]["Set-Cookie"] = $cookie.serialize
    
    response
      
      #[200, {"Content-type" => "text/html", "class_name" => "Login", "method_name" => "login"}, [File.read("#{directory}/success.html")]]  
    else  #'_clarity_session={"NomNom": "Hello World", "YumYum": "cookie2"}; Max-Age=100000; Path=\/me;'
      [401, {"Content-type" => "text/html", "class_name" => "Login", "method_name" => "login"}, [File.read("#{directory}/failed.html")]]  
    end
  end
end