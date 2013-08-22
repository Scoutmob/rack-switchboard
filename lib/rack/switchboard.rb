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
      create_rewrite.call(env)
    end

    protected
      def create_rewrite
        store = create_store(@options[:store])
        Rack::Rewrite.new(@app) do
          instance_eval(&@config_block) if @config_block
          (store.fetch_rules || []).each do |rule|
            rules << rule
          end
        end
      end

  end
end

