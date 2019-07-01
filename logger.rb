require "time"

class Logger

  def logger(return_code, class_name, method_name)
    t = Time.now
    puts "[#{t.ctime}] #{return_code}, #{class_name}, #{method_name} "
  end
end
