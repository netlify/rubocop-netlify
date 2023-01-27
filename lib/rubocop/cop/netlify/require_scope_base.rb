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
              limits: limits
            }
          else
            @method_protection = node.method_name
          end
        end

        private

        def all_method_names_for_scope_checking
          [:fake_method_for_scope_checking] + @require_scopes.map { |rs| (rs[:limits][:only] || []) +(rs[:limits][:except] || [])  }.reduce([], &:+).uniq
        end

        def scopes_for_action(action)
          matches = []
          @require_scopes.each do |require_scope|
            if require_scope[:limits][:only]
              matches << require_scope[:scopes] if require_scope[:limits][:only].include?(action)
            elsif require_scope[:limits][:except]
              matches << require_scope[:scopes] unless require_scope[:limits][:except].include?(action)
            else
              matches << require_scope[:scopes]
            end
          end

          return matches
        end
      end
    end
  end
end
