# frozen_string_literal: true

module RuboCop
  module Cop
    module Netlify
      # This cop enforces the test to use `as:` option for encoding the request
      # with a content type.
      #
      # @example
      #   # bad
      #   post "api/v1/user", params: { name: "Esteban" }
      #
      #   # good
      #   post "api/v1/user", params: { name: "Esteban" }, as: :json
      class RequestTestsParamEncoding < Cop
        MSG = "%<http_method>s with params should be used with as: to specify a param encoding"

        def_node_matcher :request_method, <<~PATTERN
          (send nil? ${:patch :post :put} {(dstr ...) (str _)} (hash $...))
        PATTERN

        def_node_matcher :has_params?, <<~PATTERN
          (pair (sym :params) _)
        PATTERN

        def_node_matcher :has_as?, <<~PATTERN
          (pair (sym :as) _)
        PATTERN

        def on_send(node)
          request_method(node) do |http_method, option_pairs|
            params = option_pairs.detect { |pair| has_params?(pair) }
            as = option_pairs.detect { |pair| has_as?(pair) }
            if params && !as
              message = format(MSG, http_method: http_method)
              add_offense(node, message: message)
            end
          end
        end
      end
    end
  end
end
