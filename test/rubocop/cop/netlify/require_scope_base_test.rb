# frozen_string_literal: true

require 'test_helper'

class RequireScopeBaseTest < Minitest::Test
  def test_no_scopes
    assert_no_offenses <<~RUBY
      class Controller
      end
    RUBY

    assert_equal [], @cop.instance_variable_get('@require_scopes')
    assert_equal [:fake_method_for_scope_checking], @cop.send(:all_method_names_for_scope_checking)
    assert_equal [], @cop.send(:scopes_for_action, :fake_method_for_scope_checking)
  end

  def test_singular_scopes
    assert_no_offenses <<~RUBY
      class Controller
        require_scope "all:read"
      end
    RUBY

    assert_equal [{:scopes=>["all:read"], :limits=>{}}], @cop.instance_variable_get('@require_scopes')
    assert_equal [:fake_method_for_scope_checking], @cop.send(:all_method_names_for_scope_checking)
    assert_equal [["all:read"]], @cop.send(:scopes_for_action, :fake_method_for_scope_checking)    
  end  

  def test_list_of_scopes
    assert_no_offenses <<~RUBY
      class Controller
        require_scope "all:read", "user:read"
      end
    RUBY

    assert_equal [{:scopes=>["all:read", "user:read"], :limits=>{}}], @cop.instance_variable_get('@require_scopes')
    assert_equal [:fake_method_for_scope_checking], @cop.send(:all_method_names_for_scope_checking)
    assert_equal [["all:read", "user:read"]], @cop.send(:scopes_for_action, :fake_method_for_scope_checking)    
  end 

  def test_only_clause_singular
    assert_no_offenses <<~RUBY
      class Controller
        require_scope "all:read", "user:read", only: :index
      end
    RUBY

    assert_equal [{:scopes=>["all:read", "user:read"], :limits=>{only: [:index]}}], @cop.instance_variable_get('@require_scopes')
    assert_equal [:fake_method_for_scope_checking, :index], @cop.send(:all_method_names_for_scope_checking)
    assert_equal [["all:read", "user:read"]], @cop.send(:scopes_for_action, :index)    
    assert_equal [], @cop.send(:scopes_for_action, :fake_method_for_scope_checking)
  end   

  def test_only_clause_array
    assert_no_offenses <<~RUBY
      class Controller
        require_scope "all:read", "user:read", only: [:index, :delete]
      end
    RUBY

    assert_equal [{:scopes=>["all:read", "user:read"], :limits=>{only: [:index, :delete]}}], @cop.instance_variable_get('@require_scopes')
    assert_equal [:fake_method_for_scope_checking, :index, :delete], @cop.send(:all_method_names_for_scope_checking)
    assert_equal [["all:read", "user:read"]], @cop.send(:scopes_for_action, :index)
    assert_equal [["all:read", "user:read"]], @cop.send(:scopes_for_action, :delete)
    assert_equal [], @cop.send(:scopes_for_action, :fake_method_for_scope_checking)
  end   

  def test_except_clause_singular
    assert_no_offenses <<~RUBY
      class Controller
        require_scope "all:read", "user:read", except: :index
      end
    RUBY

    assert_equal [{:scopes=>["all:read", "user:read"], :limits=>{except: [:index]}}], @cop.instance_variable_get('@require_scopes')
    assert_equal [:fake_method_for_scope_checking, :index], @cop.send(:all_method_names_for_scope_checking)
    assert_equal [], @cop.send(:scopes_for_action, :index)
    assert_equal [["all:read", "user:read"]], @cop.send(:scopes_for_action, :fake_method_for_scope_checking)
  end   
  
  def test_except_clause_array
    assert_no_offenses <<~RUBY
      class Controller
        require_scope "all:read", "user:read", except: [:index, :delete]
      end
    RUBY

    assert_equal [{:scopes=>["all:read", "user:read"], :limits=>{except: [:index, :delete]}}], @cop.instance_variable_get('@require_scopes')
    assert_equal [:fake_method_for_scope_checking, :index, :delete], @cop.send(:all_method_names_for_scope_checking)
    assert_equal [], @cop.send(:scopes_for_action, :index)
    assert_equal [], @cop.send(:scopes_for_action, :delete)    
    assert_equal [["all:read", "user:read"]], @cop.send(:scopes_for_action, :fake_method_for_scope_checking)
  end 

  def test_multiple_matching_scopes
    assert_no_offenses <<~RUBY
      class Controller
        require_scope "all:read", "user:read", except: [:index, :delete]
        require_scope "all:write", "user:write", only: [:destroy]
      end
    RUBY

    assert_equal [
      {:scopes=>["all:read", "user:read"], :limits=>{except: [:index, :delete]}},
      {:scopes=>["all:write", "user:write"], :limits=>{only: [:destroy]}}
    ], @cop.instance_variable_get('@require_scopes')
    assert_equal [:fake_method_for_scope_checking, :index, :delete, :destroy], @cop.send(:all_method_names_for_scope_checking)
    assert_equal [], @cop.send(:scopes_for_action, :index)
    assert_equal [], @cop.send(:scopes_for_action, :delete)    
    assert_equal [
      ["all:read", "user:read"],
      ["all:write", "user:write"]
    ], @cop.send(:scopes_for_action, :destroy)
    assert_equal [["all:read", "user:read"]], @cop.send(:scopes_for_action, :fake_method_for_scope_checking)
  end   
end
