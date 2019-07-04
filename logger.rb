require "time"

class Logger

  def logger(response)
    t = Time.now
    return_code = response.code
    class_name = response['class_name']
    method_name = response['method_name']
    puts "[#{t.ctime}] #{return_code}, #{class_name}, #{method_name} "
  end
end
