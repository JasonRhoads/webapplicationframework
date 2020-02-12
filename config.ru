require 'rubygems'
require 'bundler/setup'

require './clarity'
require './myrackmiddleware'

use Rack::Reloader
use MyRackMiddleware
CLARITY_HOST = ENV['CLARITY_HOST'] ? ENV['CLARITY_HOST'] : 'localhost'
CLARITY_PORT = ENV['CLARITY_PORT'] ? ENV['CLARITY_PORT'].to_i : 9292

Rack::Server.start(
  app: Clarity.new,
  Host: CLARITY_HOST,
  Port: CLARITY_PORT,
)

#run Clarity.new
#run lambda { |env| [200, {"Content-Type" => "text/plain"},["Hello. The time is #{Time.now}"]]}