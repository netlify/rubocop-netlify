# frozen_string_literal: true

require 'test_helper'

class RequireScopeExplicitTest < Minitest::Test
  def test_offense_no_explicit_scope_defined
    assert_offense <<~RUBY
      class Controller
        def index
        ^^^^^^^^^ Missing scope definition. For mistake-proofing, add an explicit `require_scope ...` or `require_scope ..., only: :index` to this class (not via a concern or ancestor). Note also that this is a good moment to consider if adding a new scope makes sense! If in doubt ping @merlyn_at_netlify or @dustincrogers.
        end
      end
    RUBY
  end  

  def test_offense_no_explicit_scope_defined_on_child_class
    assert_offense <<~RUBY
      class BaseController
        require_scope "public"
      end

      class Controller < BaseController
        def index
        ^^^^^^^^^ Missing scope definition. For mistake-proofing, add an explicit `require_scope ...` or `require_scope ..., only: :index` to this class (not via a concern or ancestor). Note also that this is a good moment to consider if adding a new scope makes sense! If in doubt ping @merlyn_at_netlify or @dustincrogers.
        end
      end
    RUBY
  end  

  def test_no_offense_scope_defined
    assert_no_offenses <<~RUBY
      class Controller
        require_scope "all:read"
        def index
        
        end
      end
    RUBY
  end   
end
