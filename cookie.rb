require "rack/request"
require "json"
require "pry"
require "blowfish"
require "base64"

class Cookie < Rack::Request
  def initialize(request, cookie_string = request.env["HTTP_COOKIE"])
    @key = Blowfish::Key.generate(ENV["CLARITY_KEY"])
    cookie_string.split("=").tap do |c|
      @name = c[0]
      #decrypt cookie here
      begin
        @data = JSON.parse(Blowfish.decrypt(Base64.decode64(c[1]), @key))
      rescue
        @data = JSON.parse(c[1])
      end
    end
    
    @meta_data = {"Path" => "/"}
    @has_changed = false
  end
    
  def serialize
    puts "before encryption: #{@data.to_json}"
    serialized_cookie = "#{@name}=#{Base64.encode64(Blowfish.encrypt(@data.to_json, @key)).chomp}; "
    @meta_data.each {|key, value| serialized_cookie += "#{key}=#{value}; "}
    puts "after encryption: #{serialized_cookie}"
    serialized_cookie
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

  def self.create
    $cookie = Cookie.new(request, request.env["HTTP_COOKIE"] || '_clarity_session={}')
  end
  
end
