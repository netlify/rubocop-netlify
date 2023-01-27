# frozen_string_literal: true

require_relative "require_scope_base"

module RuboCop
  module Cop
    module Netlify
      # This cop checks an explicit OAuth scope is defined directly by the contoller class (not elsewhere)
      #
      # @example
      #   # bad
      #   def index
      #
      #   # good
      #   require_scope "all:read"
      #   def index
      class RequireScopeExplicit < RequireScopeBase
        def on_def(node)
          return unless @is_controller
          return unless @method_protection == :public

          scopes = scopes_for_action(node.method_name)

          if scopes.empty?
            add_offense(node, message: format("Missing scope definition. For mistake-proofing, add an explicit `require_scope ...` or `require_scope ..., only: :%s` to this class (not via a concern or ancestor). Note also that this is a good moment to consider if adding a new scope makes sense! If in doubt ping @merlyn_at_netlify or @dustincrogers.", node.method_name))
          end
        end
      end
    end
  end
end
