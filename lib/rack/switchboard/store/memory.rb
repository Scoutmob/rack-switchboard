require 'rack/rewrite/rule'

module Rack
  class Switchboard
    module Store
      class Memory
        @@rules = []

        def initialize(options = {})
        end

        def fetch_rules
          @@rules.dup
        end

        def persist_rules(rules)
          @@rules = rules
        end
      end
    end
  end
end
