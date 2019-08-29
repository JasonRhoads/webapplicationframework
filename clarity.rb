require "rack"
require "logger"
require_relative "routes"
require_relative "mime_types"
require_relative "dynamic_request_dispatcher"
require_relative "default_request_dispatcher"

class Clarity
   def call env
    request = Rack::Request.new(env)
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::DEBUG
    
    directory = ENV['CLARITY_DIRECTORY'] ? ENV['CLARITY_DIRECTORY'] : File.expand_path(File.dirname(__FILE__)) + "/public"    
    file = directory + request.path
    file += "/index.html" if File.directory?(file)
    
    mime_types = MimeTypes.get_mime_types(directory)
    content = mime_types[File.extname(file)]    
    routes = Routes.get_routes(directory)
            
    http_method_and_path = "#{request.request_method} #{request.path.downcase}"
    if routes.has_key? http_method_and_path
      DynamicRequestDispatcher.dynamic_request_dispatcher(routes[http_method_and_path], request, directory, mime_types)
    else
      DefaultRequestDispatcher.default_request_dispatcher(request, directory, mime_types)
    end
  end
end


