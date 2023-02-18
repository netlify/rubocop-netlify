# frozen_string_literal: true

require 'test_helper'

class RequireScopeBaseTest < Minitest::Test
  def require_scopes_defined
    return @cop.instance_variable_get('@require_scopes').map { |rs| rs.slice(:scopes, :limits) }
  end

  def scopes_for_method(method_name)
    return @cop.send(:require_scopes_for_method, method_name).map { |rs| rs[:scopes] }
  end

  def test_no_scopes
    assert_no_offenses <<~RUBY
      class Controller
      end
    RUBY

    assert_equal [], require_scopes_defined
  end

  def test_singular_scopes
    assert_no_offenses <<~RUBY
      class Controller
        require_scope "all:read"
      end
    RUBY

    assert_equal [{:scopes=>["all:read"], :limits=>{}}], require_scopes_defined
    assert_equal [["all:read"]], scopes_for_method(:any_method)
  end  

  def test_list_of_scopes
    assert_no_offenses <<~RUBY
      class Controller
        require_scope "all:read", "user:read"
      end
    RUBY

    assert_equal [{:scopes=>["all:read", "user:read"], :limits=>{}}], require_scopes_defined
    assert_equal [["all:read", "user:read"]], scopes_for_method(:any_method)
  end 

  def test_only_clause_singular
    assert_no_offenses <<~RUBY
      class Controller
        require_scope "all:read", "user:read", only: :index
      end
    RUBY

    assert_equal [{:scopes=>["all:read", "user:read"], :limits=>{only: [:index]}}], require_scopes_defined
    assert_equal [["all:read", "user:read"]], scopes_for_method(:index)    
    assert_equal [], scopes_for_method(:any_other_method)
  end   

  def test_only_clause_array
    assert_no_offenses <<~RUBY
      class Controller
        require_scope "all:read", "user:read", only: [:index, :delete]
      end
    RUBY

    assert_equal [{:scopes=>["all:read", "user:read"], :limits=>{only: [:index, :delete]}}], require_scopes_defined
    assert_equal [["all:read", "user:read"]], scopes_for_method(:index)
    assert_equal [["all:read", "user:read"]], scopes_for_method(:delete)
    assert_equal [], scopes_for_method(:any_other_method)
  end   

  def test_except_clause_singular
    assert_no_offenses <<~RUBY
      class Controller
        require_scope "all:read", "user:read", except: :index
      end
    RUBY

    assert_equal [{:scopes=>["all:read", "user:read"], :limits=>{except: [:index]}}], require_scopes_defined
    assert_equal [], scopes_for_method(:index)
  end   
  
  def test_except_clause_array
    assert_no_offenses <<~RUBY
      class Controller
        require_scope "all:read", "user:read", except: [:index, :delete]
      end
    RUBY

    assert_equal [{:scopes=>["all:read", "user:read"], :limits=>{except: [:index, :delete]}}], require_scopes_defined
    assert_equal [], scopes_for_method(:index)
    assert_equal [], scopes_for_method(:delete)    
    assert_equal [["all:read", "user:read"]], scopes_for_method(:any_other_method)
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
    ], require_scopes_defined
    assert_equal [], scopes_for_method(:index)
    assert_equal [], scopes_for_method(:delete)    
    assert_equal [
      ["all:read", "user:read"],
      ["all:write", "user:write"]
    ], scopes_for_method(:destroy)
  end   
end
