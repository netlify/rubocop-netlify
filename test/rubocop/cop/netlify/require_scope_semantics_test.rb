# frozen_string_literal: true

require 'test_helper'

class RequireScopeSemanticsTest < Minitest::Test
  def test_offense_with_scope_mismatch_single_scope
    assert_offense <<~RUBY
      class Controller
        require_scope "all:read"

        def destroy
        ^^^^^^^^^^^ Semantic naming mismatch between method `destroy` and scope `all:read`
        end
      end
    RUBY

    assert_offense <<~RUBY
      class Controller
        require_scope "all:write"

        def index
        ^^^^^^^^^ Semantic naming mismatch between method `index` and scope `all:write`
        end
      end
    RUBY
  end

  def test_offense_with_scope_mismatch_scope_list
    assert_offense <<~RUBY
      class Controller
        require_scope "public", "account:read"

        def destroy
        ^^^^^^^^^^^ Semantic naming mismatch between method `destroy` and scope `account:read`
        end
      end
    RUBY
  end

  def test_offense_with_only_and_except
    assert_offense <<~RUBY
      class Controller
        require_scope "public", "all:write", except: :destroy
        require_scope "public", "all:read", only: [:destroy]

        def delete
        end

        def destroy
        ^^^^^^^^^^^ Semantic naming mismatch between method `destroy` and scope `all:read`
        end
      end
    RUBY
  end  

  def test_no_offense_for_private_methods
    assert_no_offenses <<~RUBY
      class Controller
        require_scope "all:read"

        private

        def destroy

        end

        def delete

        end
      end
    RUBY
  end  

  def test_no_offense_unless_a_controller_class
    assert_no_offenses <<~RUBY
      class Model
        def delete
        end
      end
    RUBY
  end  
end
