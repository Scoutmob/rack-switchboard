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
        begin
          rewrite_result = create_rewrite.call(env)
          if rewrite_result != 404
            result = rewrite_result
          end
        rescue Exception => e
          process_error(e, env)
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

      def process_error(error, env)
        errors = env['rack.errors']
        log_exception(error, errors)
        if @options[:error_handler]
          begin
            @options[:error_handler].call(error)
          rescue Exception => e
            errors.write "!! Error in error handler\n"
            log_exception(e, errors)
          end
        end
        errors.flush
      end

      def log_exception(error, error_stream)
        error_stream.write error.message +
          "\n   " +
          error.backtrace.join("\n   ") +
          "\n"
      end

  end
end

