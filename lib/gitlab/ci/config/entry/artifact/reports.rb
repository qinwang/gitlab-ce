module Gitlab
  module Ci
    class Config
      module Entry
        module Artifact
          ##
          # Entry that represents a configuration of job artifact reports.
          #
          class Reports < Node
            include Validatable
            include Attributable

            ALLOWED_KEYS = %i[junit].freeze

            attributes ALLOWED_KEYS

            validations do
              validates :config, type: Hash
              validates :config, allowed_keys: ALLOWED_KEYS

              with_options allow_nil: true do
                validates :junit, type: String
              end
            end
          end
        end
      end
    end
  end
end
