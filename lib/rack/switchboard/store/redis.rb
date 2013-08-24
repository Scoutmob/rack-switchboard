require 'redis'
require 'rack/rewrite/rule'

module Rack
  class Switchboard
    module Store
      class Redis
        LIST_NAME = 'rack_switchboard:rules'

        def initialize(options = {})
          @redis = ::Redis.new(options)
        end

        def fetch_rules
          (@redis.lrange(LIST_NAME, 0, -1) || []).map do |rule_json|
            rule_config = JSON.parse(rule_json)
            Rack::Rewrite::Rule.new(
              rule_config['rule_type'].to_sym,
              rule_config['from'],
              rule_config['to'],
              rule_config['options']
            )
          end
        end

        def persist_rules(rules)
          @redis.multi do
            @redis.del(LIST_NAME)
            rules.each do |rule|
              @redis.rpush(LIST_NAME, JSON.dump(as_json(rule)))
            end
          end
        end

        protected

          def as_json(o)
            {
              :rule_type => o.rule_type,
              :from      => o.from,
              :to        => o.to,
              :options   => o.options
            }
          end

      end
    end
  end
end

