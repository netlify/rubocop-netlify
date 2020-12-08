# frozen_string_literal: true

module RuboCop
  module Cop
    module Netlify
      # This cop checks attribute assignment of Mongoid models
      #
      # @example
      #   # bad
      #   form.attributes[:email] = "bettse@netlify.com"
      #
      #   # good
      #   form.email = "bettse@netlify.com"
      class InvalidModelAssignment < Cop
        MSG = "Assigning to `attributes` will not update record"

        def on_send(node)
          if node.assign_attributes?
            add_offense(node, message: MSG)
          end
        end

        private

        def_node_matcher :assign_attributes?, <<~PATTERN
          (send (send (...) :attributes) :[]= _ _)
        PATTERN
      end
    end
  end
end
