require 'rack/rewrite/rule'

module Rack
  class Switchboard
    module Store
      class Memory
        @@rules = []
        @@not_founds = {}
        @@max_length = 50

        def initialize(options = {})
        end

        def fetch_rules
          @@rules.dup
        end

        def persist_rules(rules)
          @@rules = rules
        end

        def record_404(path_info)
          @@not_founds[path_info] = @@not_founds[path_info].to_i + 1
          if @@not_founds.length > @@max_length
            pairs = @@not_founds.inject([]) { |m,p| m << p }
            pairs.sort_by! { |v| v[1] }
            while pairs.length > @@max_length
              last = pairs.shift
              @@not_founds.delete(last[0])
            end
          end
        end

        def delete_404(path_info)
          @@not_founds.delete(path_info)
        end

        def fetch_404s
          @@not_founds.dup
        end
      end
    end
  end
end
