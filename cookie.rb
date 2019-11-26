require "rack/request"
require "json"
require "pry"

class Cookie < Rack::Request
  def initialize(request, cookie_string = request.env["HTTP_COOKIE"])
    cookie_string.split("=").tap do |c|
      @name = c[0]
      #decrypt cookie here
      @data = JSON.parse(c[1])
    end
    @meta_data = {"Path" => "/"}
    @has_changed = false
  end
    
  def serialize
    cookie_string = "#{@name}=#{@data.to_json}; "
    @meta_data.each {|key, value| cookie_string += "#{key}=#{value}; "}
    #encrypt cookie here
    cookie_string 
  end

  # @cookie["foo"] = "bar"
  def [](key)
    @data[key]
  end
  
  def []=(key, value)
    @has_changed = true
    @data[key] = value
  end

  def delete(key)
    @has_changed = true
    @data.delete(key)
  end

  def each
    @data.each{ |key, value| yield(key, value) }
  end

  def max_age
    @meta_data["Max-Age"]
  end

  def max_age=(number_of_seconds)
    @has_changed = true
    @meta_data["Max-Age"] = number_of_seconds
  end

  def expires
    @meta_data["Expires"]
  end

  def expires=(date)
    @has_changed = true
    @meta_data["Expires"] = date
  end

  def eat
    self.max_age = -1
  end

  def destroy
    eat
  end

  def path
    @meta_data["Path"]
  end
  
  def path=(path)
    @meta_data["Path"] = path
  end
  
end
