require "rack"
require "logger"
require_relative "routes"
require_relative "mime_types"
require_relative "request_dispatcher"

#cookies!! look up: how sent, how transmitted, session cookies, 
#                   persistant cookie, body, head, fields
#cukie = request.env["HTTP_COOKIE"]
#add cookie function to request. parse cookie into hash, read cookie, write cookie, serialize cookie.
#look into cookie expiration
#key  = 'hello world', parse cookie info if can...

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
      request_dispatcher.dynamic_request_dispatcher(routes[http_method_and_path], request)
    else
      request_dispatcher.default_request_dispatcher(request)
    end
  end
end