module Rack
  class Switchboard
    module StoreLoader
      protected
        def create_store(options = :memory)
          config = options ? options.dup : :memory
          provider, config = if config.kind_of? Hash
            [ config.delete(:provider), config ]
          else
            [ config, {} ]
          end

          require "rack/switchboard/store/#{provider}"
          Rack::Switchboard::Store.const_get(classify(provider)).new(config)
        end

        def classify(provider)
          provider.to_s.gsub(/^([a-z])/){|m| m[0].upcase}.gsub(/_([a-z])/){|m| m[1].upcase}
        end

    end
  end
end
