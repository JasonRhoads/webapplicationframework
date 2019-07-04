require "time"
require "logger"

class Logger
  def debug_logger(response)
    t = Time.now
    status = response.status
    class_name = response.get_header('class_name')
    method_name = response.get_header('method_name')
    puts "[#{t.ctime}] #{status}, #{class_name}, #{method_name} "
  end
end
