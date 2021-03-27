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

        def_node_matcher :assign_attributes?, <<~PATTERN
          (send (send (...) :attributes) :[]= _ _)
        PATTERN

        def on_send(node)
          add_offense(node) if assign_attributes? node
        end
      end
    end
  end
end
