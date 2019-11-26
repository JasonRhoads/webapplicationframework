require "logger"
require_relative "cookie"

class RequestDispatcher
  def initialize(app_root, mime_types, logger = Logger.new(STDOUT))
    @logger = logger
    @logger.level = Logger::DEBUG

    @app_root = app_root
    @mime_types = mime_types
  end

  def dynamic_request_dispatcher(controller_file_name, request)
    *path_names, class_name, method_name = controller_file_name.scan(/(\w+\/|\w+)/).flatten
    file_name = [path_names, class_name, ".rb"].flatten.join
    class_name = class_name.split('_').map{|cn| cn.capitalize}.join
    if File.exist?("#{@app_root}/../controllers/#{file_name}") == false
      file_name = [path_names, class_name, ".rb"].flatten.join
    end
    load "#{@app_root}/../controllers/#{file_name}"
    instance = Object.const_get(class_name).new
    instance_method = instance.method(method_name)

    $cookie = Cookie.new(request, request.env["HTTP_COOKIE"] || '_clarity_session={}')
    response = instance_method.call(request, @app_root, @mime_types)
    response[1]["Set-Cookie"] = $cookie.serialize

    @logger.debug %{class:#{class_name}, method:#{method_name}, status code:#{response[0]}}
    response
  end

  def default_request_dispatcher(request)
    file = @app_root + request.path
    file += "/index.html" if File.directory?(file)
    if File.exist?(file)
      $cookie = Cookie.new(request, request.env["HTTP_COOKIE"] || '_clarity_session={}')
      response = [200, {"Content-type" => @mime_types[File.extname(file)]}, [File.read(file, mode: "rb")]] 
      response[1]["Set-Cookie"] = $cookie.serialize
      response
    else
      [404, {"Content-type" => "text/html"}, [File.read("#{app_root}/doesnotexist.html")]]
    end
  end
end