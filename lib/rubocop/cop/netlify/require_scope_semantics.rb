# frozen_string_literal: true

require_relative "require_scope_base"

module RuboCop
  module Cop
    module Netlify
      # This cop checks OAuth scope semantic mismatches
      #
      # @example
      #   # bad
      #   require_scope "all:read"
      #   def destroy
      #
      #   # good
      #   require_scope "all:read"
      #   def index
      class RequireScopeSemantics < RequireScopeBase
        def on_def(node)
          return unless @is_controller
          return unless @method_protection == :public

          require_scopes = require_scopes_for_method(node.method_name)
          return if require_scopes.empty?
          require_scope = require_scopes.last # this is the observed matching behavior
          scopes = require_scope[:scopes]

          if ["new", "update", "create", "destroy", "delete"].any? { |s| node.method_name.to_s.include?(s) }
            read_semantic_scopes = scopes.select { |scope| scope.include?("read") }
            unless read_semantic_scopes.empty?
              add_offense(node, message: format("Semantic naming mismatch between method `%s` and scope `%s`", node.method_name, read_semantic_scopes[0]))
            end
          end

          if ["index", "show", "list"].any? { |s| node.method_name.to_s.include?(s) }
            write_semantic_scopes = scopes.select { |scope| scope.include?("write") }
            unless write_semantic_scopes.empty?
              add_offense(node, message: format("Semantic naming mismatch between method `%s` and scope `%s`", node.method_name, write_semantic_scopes[0]))
            end
          end
        end
      end
    end
  end
end
