require "rack/switchboard/version"
require 'rack/rewrite'

module Rack
  class Switchboard
    def initialize(app, options = {}, &block)
      @app = app
      @rewrite = create_rewrite(app, options, &block)
    end

    def call(env)
      @rewrite.call(env)
    end

    protected
      def create_rewrite(app, options, &block)
        store = create_store(options)
        Rack::Rewrite.new(app) do
          instance_eval(&block) if block
          (store.fetch_rewrite_rules || []).each do |rule|
            rules << rule
          end
        end
      end

      def create_store(options)
        config = options[:store] || :memory
        provider, config = if config.kind_of? Hash
          [ config.delete(:provider), config ]
        else
          [ config, {} ]
        end

        require "rack/switchboard/store/#{provider}"
        klass = Rack::Switchboard::Store.const_get(classify(provider)).new(config)
      end

      def classify(provider)
        provider.to_s.gsub(/^([a-z])/){|m| m[0].upcase}.gsub(/_([a-z])/){|m| m[1].upcase}
      end
  end
end

