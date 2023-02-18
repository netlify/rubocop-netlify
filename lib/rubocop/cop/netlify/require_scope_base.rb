# frozen_string_literal: true

module RuboCop
  module Cop
    module Netlify
      class RequireScopeBase < Cop
        RESTRICT_ON_SEND = [:require_scope, :public, :private, :protected]
        
        def on_class(node)
          @require_scopes = []
          @method_protection = :public
          @is_controller = node.identifier.short_name.to_s.end_with?("Controller")
        end
        
        def on_send(node)
          if node.method_name == :require_scope
            scopes = []
            limits = {}
            node.arguments.each do |option|
              if option.is_a? RuboCop::AST::StrNode
                scopes << option.value
              elsif option.is_a? RuboCop::AST::HashNode
                option.pairs.each do |pair|
                  if pair.value.is_a? RuboCop::AST::ArrayNode
                    limits[pair.key.value] = pair.value.values.map(&:value)
                  elsif pair.value.is_a? RuboCop::AST::SymbolNode
                    limits[pair.key.value] = [pair.value.value]
                  end
                end
              end
            end

            @require_scopes << {
              scopes: scopes,
              limits: limits,
              node: node
            }
          else
            @method_protection = node.method_name
          end
        end

        private

        def require_scopes_for_method(action)
          matches = []
          @require_scopes.each do |require_scope|
            if require_scope[:limits][:only]
              matches << require_scope if require_scope[:limits][:only].include?(action)
            elsif require_scope[:limits][:except]
              matches << require_scope unless require_scope[:limits][:except].include?(action)
            else
              matches << require_scope
            end
          end

          return matches
        end
      end
    end
  end
end
