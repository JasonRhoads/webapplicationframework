require_relative '..\cookie'
require 'sequel'
require 'sqlite3'
require "bcrypt"
require 'pry'

class Login
  def login(request, directory, mime_types)
    db = Sequel.connect('sqlite://database.db')

    password = db['select password from users where first_name = ?', request.params["username"]].first[:password].chomp
    username = db['select first_name from users where first_name = ?', request.params["username"]].first[:first_name]

    $cookie["Name"] = username
    $cookie["NomNom"] = "Choco"
    $cookie.max_age = 100000
    puts username
    puts password
    puts request.params["password"]
    #binding.pry
    hashed_password = BCrypt::Password.new(password)
    puts "Correct password? " + (hashed_password == BCrypt::Password.create("pass1")).to_s
    if ((username == request.params["username"]) && (hashed_password == request.params["password"]))
      [200, {"Content-type" => "text/html", "class_name" => "Login", "method_name" => "login"}, [File.read("#{directory}/success.html")]]  
    else  #'_clarity_session={"NomNom": "Hello World", "YumYum": "cookie2"}; Max-Age=100000; Path=\/me;'
      [401, {"Content-type" => "text/html", "class_name" => "Login", "method_name" => "login"}, [File.read("#{directory}/failed.html")]]  
    end
  end
end