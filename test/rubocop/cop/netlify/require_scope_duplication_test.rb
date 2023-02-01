# frozen_string_literal: true

require 'test_helper'

class RequireScopeDuplicationTest < Minitest::Test
  def test_offense_duplicate_conflicting_scopes
    assert_offense <<~RUBY
      class Controller
        require_scope "public"
        require_scope "all:read"
        ^^^^^^^^^^^^^^^^^^^^^^^^ Multiple overlapping definitions: ["public"] and ["all:read"].
      end
    RUBY
  end

  def test_offense_duplicate_conflicting_scopes_with_excepts_and_onlys
    assert_offense <<~RUBY
      class Controller
        require_scope "all:read", "user:read", except: [:index, :delete]
        require_scope "all:write", "user:write", only: [:destroy]
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Multiple overlapping definitions: [\"all:read\", \"user:read\"] and [\"all:write\", \"user:write\"].
      end
    RUBY
  end

  def test_no_offense_non_overlapping_scopes
    assert_no_offenses <<~RUBY
      class Controller
        require_scope "all:read", only: [:show]
        require_scope "all:read", only: [:index]
      end
    RUBY
  end   
end
