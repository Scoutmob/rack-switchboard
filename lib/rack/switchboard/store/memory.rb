require 'rack/rewrite/rule'

module Rack
  class Switchboard
    module Store
      class Memory < Rack::Rewrite::RuleSet
        def initialize(options = {})
          super()
          r301 '/h', '/hello'
        end
        alias :fetch_rewrite_rules :rules
      end
    end
  end
end
