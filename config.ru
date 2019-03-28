require './my_app'
require './myrackmiddleware'
use Rack::Reloader
use MyRackMiddleware
run MyApp.new
#run lambda { |env| [200, {"Content-Type" => "text/plain"},["Hello. The time is #{Time.now}"]]}