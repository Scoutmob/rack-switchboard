require 'rack/switchboard/store_loader'
require 'json'

module Rack
  class Switchboard
    class Admin
      def initialize(options = {})
        @map = Rack::URLMap.new(
          '/rewrites' => Rewrites.new(options),
          '/'         => Rack::File.new(::File.join(::File.dirname(__FILE__), '..', '..', '..', 'public'))
        )
      end

      def call(env)
        @map.call(env)
      end

      class Home
        def call(env)
          [ 200,
            { 'Content-Type' => 'text/html' }, 
            ::File.read(admin_index)
          ]
        end

        protected
          def admin_index
            
          end
      end

      class Rewrites
        include StoreLoader

        def initialize(options = {})
          @store_options = options[:store]
        end

        def call(env)
          if env['REQUEST_METHOD'] == 'GET'
            list_rules(env)
          elsif env['REQUEST_METHOD'] == 'PUT'
            update_rule(env)
          elsif env['REQUEST_METHOD'] == 'DELETE'
            delete_rule(env)
          elsif env['REQUEST_METHOD'] == 'POST'
            create_rule(env)
          else
            [404, {'Content-Type' => 'text/plain'}, ['Not Found']]
          end
        end

        protected
          def list_rules(env)
            [ 200,
              {'Content-Type' => 'application/json'},
              [JSON.dump(as_json(create_store(@store_options).fetch_rules))]
            ]
          end

          def create_rule(env)
            req = Rack::Request.new(env)
            store = create_store(@store_options)
            rules = store.fetch_rules
            rules << rule = new_rule(params(req))
            store.persist_rules(rules)

            [ 201,
              {'Content-Type' => 'application/json'},
              [JSON.dump(as_json(rule)), env.inspect]
            ]
          end

          def update_rule(env)
            req = Rack::Request.new(env)
            store = create_store(@store_options)
            rules = store.fetch_rules
            rules[req.params['index'].to_i] = rule = new_rule(params(req))
            store.persist_rules(rules)

            [ 200,
              {'Content-Type' => 'application/json'},
              [JSON.dump(as_json(rule))]
            ]
          end

          def delete_rule(env)
            req = Rack::Request.new(env)
            store = create_store(@store_options)
            rules = store.fetch_rules
            rules.delete_at(req.params['index'].to_i)
            store.persist_rules(rules)

            [ 200,
              {'Content-Type' => 'application/json'},
              ['OK']
            ]
          end

          def new_rule(params)
            Rack::Rewrite::Rule.new(
              params['rule_type'].to_sym,
              params['from'],
              params['to'],
              {}
            )
          end

          def params(req)
            params = req.params.dup
            reqBody = req.body.read
            if !reqBody.nil? and reqBody.strip.length > 0
              json = JSON.parse(reqBody) rescue nil
              params.merge!(json) if json
            end
            params
          end

          def as_json(o)
            if o.kind_of?(Enumerable)
              o.map { |r| as_json(r) }
            else
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
end


