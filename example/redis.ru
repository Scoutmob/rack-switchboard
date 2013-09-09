require 'rack/switchboard'
require 'rack/switchboard/admin'

map '/admin' do
  run Rack::Switchboard::Admin.new(
    :store => {
      :provider => :redis,
      :host => '127.0.0.1',
      :port => 6379
    }
  )
end

map '/' do
  use Rack::Switchboard, :store => {
    :provider => :redis,
    :host => '127.0.0.1',
    :port => 6379
  }
  run proc { |env|
    env['PATH_INFO'] == '/hello' ?
      [200, {"Content-Type" => "text/plain"}, ["Hello Rack!"]] :
      [404, {"Content-Type" => "text/plain"}, ["Not Found"]]
  }
end

