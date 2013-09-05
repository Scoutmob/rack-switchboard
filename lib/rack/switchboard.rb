require "rack/switchboard/version"
require "rack/switchboard/store_loader"
require 'rack/rewrite'

module Rack
  class Switchboard
    include StoreLoader

    def initialize(app, options = {}, &block)
      @app = app
      @options = options
      @config_block = block
    end

    def call(env)
      result = @app.call(env)
      if result[0].to_i == 404
        rewrite_result = create_rewrite.call(env)
        if rewrite_result != 404
          result = rewrite_result
        end
      end
      result
    end

    protected
      def create_rewrite
        store = create_store(@options[:store])
        Rack::Rewrite.new(Proc.new { |env| [404, {}, []] }) do
          instance_eval(&@config_block) if @config_block
          (store.fetch_rules || []).each do |rule|
            rules << rule
          end
        end
      end

  end
end

