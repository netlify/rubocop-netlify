module RuboCop
    module Cop
      module Netlify
        # This cop checks for use of Rails.env to check the environment
        #
        # @example
        #   # bad
        #   Rails.env.production?
        #
        #   # good
        #   Netlify.env.production?
        class RailsEnvCheck < Cop
          MSG = "Prefer using `Netlify.env` instead of `Rails.env` to check the environment"

          def_node_matcher :rails_env?, <<~PATTERN
            (send (send (const {nil? cbase} :Rails) :env) /staging?|production?/)
          PATTERN

          def on_send(node)
            add_offense(node) if rails_env? node
          end
        end
      end
    end
  end
