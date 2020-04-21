require "rack"
require "logger"
require_relative "routes"
require_relative "mime_types"
require_relative "request_dispatcher"

#display encounters as table
#database wrapper class

class Clarity
   def call env
    request = Rack::Request.new(env)
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::DEBUG
    
    app_root = ENV['CLARITY_DIRECTORY'] ? ENV['CLARITY_DIRECTORY'] : File.expand_path(File.dirname(__FILE__)) + "/public"    
    file = app_root + request.path
    file += "/index.html" if File.directory?(file)
    
    mime_types = MimeTypes.new(app_root)
    routes = Routes.new(app_root)
    request_dispatcher = RequestDispatcher.new(app_root, mime_types, @logger)
    
    http_method_and_path = "#{request.request_method} #{request.path.downcase}"
    if routes.has_key?(http_method_and_path)
      begin
        request_dispatcher.dynamic_request_dispatcher(routes[http_method_and_path], request)
      rescue LoadError, NameError => e
        error_type = e.is_a?(LoadError) ? "load class" : "find method"
        @logger.error "#{http_method_and_path}: #{e.message}: failed to #{error_type}, check routes.txt"
        [404, {"Content-type" => "text/html"}, [File.read("#{app_root}/doesnotexist.html")]]                
      end
    else
      request_dispatcher.default_request_dispatcher(request)
    end
  end
end