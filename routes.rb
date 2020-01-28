require 'logger'

class Routes
  def initialize(app_root)
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::DEBUG
    @routes = {}
    routes_file = File.open("#{app_root}/../controllers/routes.txt")
    routes_file.each do |line|
      http_method_and_path, callback = line.scan(/(\w+\s+(?:\/\s|\/\w+)+)\s*(\w+#\w+)/)
        .flatten
      if check_http_method(http_method_and_path)
        @routes[http_method_and_path] = callback
      else
        @logger.debug "Invalid http method on line: #{routes_file.lineno}. #{line} in the routes.txt file"
      end
    end
  end

  def has_key?(key)
    @routes.has_key?(key)
  end

  def [](key)
    @routes[key]
  end

  def check_http_method(http_method_and_path)
    http_method = http_method_and_path.split(" ")[0]
    %{GET POST PUT HEAD DELETE CONNECT OPTIONS TRACE PATCH}.include?(http_method.upcase)
  end
end