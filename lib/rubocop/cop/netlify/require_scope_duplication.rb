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
      class RequireScopeDuplication < RequireScopeBase
        def on_def(node)
          return unless @is_controller
          return unless @method_protection == :public
      
          require_scopes = require_scopes_for_method(node.method_name)
          if require_scopes.size > 1
            add_offense(require_scopes.last[:node], message: "Multiple overlapping definitions: #{require_scopes.map { |rs| rs[:scopes].inspect }.join(" and ")}.")
          end
        end
      end
    end
  end
end
