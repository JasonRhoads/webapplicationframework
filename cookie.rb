require "rack/request"

class Cookie < Rack::Request
  def initialize(request, cookie_string = request.env["HTTP_COOKIE"])
    @cookie = cookie_string
    puts @cookie
    @is_cookie_hash = false 
  end
    
  def serialize
    return @cookie if !@is_cookie_hash
    cookie_string = ""
    @cookie.each {|key, value| cookie_string += "#{key}=#{value}; "}
    @is_cookie_hash = false
    @cookie = cookie_string 
  end

  def hash_it
    return @cookie if @is_cookie_hash
    cookie_array = @cookie.split("; ")
    cookie_hash = {}
    cookie_array.each do |c|
      key, value = c.split("=").flatten
      cookie_hash[key] = value
    end
    @is_cookie_hash = true
    @cookie = cookie_hash     
  end

  def add_field(key, value)
    return @cookie[key] = value if @is_cookie_hash
    @cookie += "#{key}=#{value}; "
  end

  def delete_field(key)
    return @cookie.delete(key) if @is_cookie_hash
    hash_it
    delete_field(key)
    serialize
  end

  def each
    hash_it
    cookie_string = ""
    @cookie.each {|key, value| cookie_string += "#{key} = #{value} "}
    cookie_string
  end

  def add_max_age(number_of_seconds)
    add_field("Max-Age", number_of_seconds)
  end

  def add_expires(time)
    add_field("Expires", time)
  end

  def eat_cookie
    add_max_age(-1)
  end

  def delete_cookie
    eat_cookie
  end

  #cookie = Cookie.new("Nom=Hello World")
  #puts cookie
  #puts cookie.serialize
  #puts cookie.hash_it
  #cookie.add_field("test", 12345)
  #puts cookie
  #puts cookie.serialize
  #puts cookie.hash_it
  #cookie.delete_field("test")
  #puts cookie
  #puts cookie.serialize
  #puts cookie.hash_it
  #puts cookie
  #puts cookie.serialize
  #cookie.add_field("test", 12345)
  #puts cookie.serialize
  #cookie.delete_field("test")
  #puts cookie.serialize
  #puts cookie.hash_it
  
end
