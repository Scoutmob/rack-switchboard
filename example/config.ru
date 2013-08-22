require 'rack/switchboard'
require 'rack/switchboard/admin'

use Rack::Switchboard do
  # You can specify a Rack::Rewrite configuration block
  r301 '/hi', '/hello'
end

run proc { |env|
  env['PATH_INFO'] == '/hello' ?
    [200, {"Content-Type" => "text/plain"}, ["Hello Rack!"]] :
    [404, {"Content-Type" => "text/plain"}, ["Not Found"]]
}

map '/admin' do
  run Rack::Switchboard::Admin.new
end

