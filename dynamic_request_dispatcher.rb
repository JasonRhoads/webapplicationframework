require "logger"
class DynamicRequestDispatcher
  def self.dynamic_request_dispatcher(controller_file_name, request, directory, mime_types)
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::DEBUG
    *path_names, class_name, method_name = controller_file_name.scan(/(\w+\/|\w+)/).flatten
    file_name = [path_names, class_name, ".rb"].flatten.join
    class_name = class_name.split('_').map{|cn| cn.capitalize}.join
    if File.exist?("#{directory}/../controllers/#{file_name}") == false
      file_name = [path_names, class_name, ".rb"].flatten.join
    end
    load "#{directory}/../controllers/#{file_name}"
    instance = Object.const_get(class_name).new
    instance_method = instance.method(method_name)
    response = instance_method.call(request, directory, mime_types)
    @logger.debug %{class:#{class_name}, method:#{method_name}, status code:#{response[0]}}
    response
  end
end