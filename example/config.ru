require 'rack/switchboard'
require 'rack/switchboard/admin'

map '/admin' do
  run Rack::Switchboard::Admin.new
end

map '/' do
  use Rack::Switchboard
  run proc { |env|
    env['PATH_INFO'] == '/hello' ?
      [200, {"Content-Type" => "text/plain"}, ["Hello Rack!"]] :
      [404, {"Content-Type" => "text/plain"}, ["Not Found"]]
  }
end
