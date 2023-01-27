# frozen_string_literal: true

require_relative "require_scope_base"

module RuboCop
  module Cop
    module Netlify
      # This cop checks OAuth scope definition duplication
      #
      # @example
      #   # bad
      #   require_scope "all:read"
      #   require_scope "public"
      #
      #   # good
      #   require_scope "public", "all:read"
      #
      #   # bad
      #   require_scope "all:read", only: :index
      #   require_scope "all:read", only: [:index, :show]
      #
      #   # good
      #   require_scope "all:read", only: [:index, :show]
      #
      #   # bad
      #   require_scope "all:read"
      #   require_scope "all:write"
      #
      #   # good
      #   require_scope "??" # Be careful! 
      class RequireScopeConfusion < RequireScopeBase
        def on_send(node)
          super(node)
          if node.method_name == :require_scope
            all_method_names_for_scope_checking.each do |method_name|
              scopes = scopes_for_action(method_name)
              if scopes.length > 1
                add_offense(node, message: "Multiple overlapping definitions: #{scopes.map(&:inspect).join(" and ")}.")
              end
            end 
          end
        end
      end
    end
  end
end
