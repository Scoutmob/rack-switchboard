require 'redis'
require 'rack/rewrite/rule'

module Rack
  class Switchboard
    module Store
      class Redis
        LIST_NAME = 'rack_switchboard:rules'
        NOT_FOUND_LIST_NAME = 'rack_switchboard:404s'

        def initialize(options = {})
          @redis = if options[:redis]
            options[:redis]
          else
            ::Redis.new(options)
          end
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

        def record_404(path_info)
          @redis.multi do
            @redis.zremrangebyrank(NOT_FOUND_LIST_NAME, 0, -50)
            @redis.zincrby(NOT_FOUND_LIST_NAME, 1, path_info)
          end
        end

        def delete_404(path_info)
          @redis.zrem(NOT_FOUND_LIST_NAME, path_info)
        end

        def fetch_404s
          @redis.zrange(NOT_FOUND_LIST_NAME, 0, -1, :with_scores => true)
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

