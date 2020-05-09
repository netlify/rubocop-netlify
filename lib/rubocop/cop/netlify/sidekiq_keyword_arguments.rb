# frozen_string_literal: true

module RuboCop
  module Cop
    module Netlify
      # This cop checks the usage of keyword arguments in Sidekiq workers.
      #
      # @example
      #   # bad
      #   def perform(user_id, name:)
      #
      #   # good
      #   def perform(user_id, name)
      class SidekiqKeywordArguments < Cop
        MSG = "Avoid keyword arguments in workers"
        OBSERVED_METHOD = :perform

        def on_def(node)
          return if node.method_name != OBSERVED_METHOD

          node.arguments.each do |argument|
            if keyword_argument?(argument)
              add_offense(node, location: :expression)
              break
            end
          end
        end

        private

        def keyword_argument?(argument)
          argument.type == :kwarg || argument.type == :kwoptarg
        end
      end
    end
  end
end
