# frozen_string_literal: true

require 'test_helper'

class RequestTestsParamEncodingTest < Minitest::Test
  def test_offense_with_patch_when_params_and_missing_as
    assert_offense <<~RUBY
      patch "/api/v1/user", params: { name: "Esteban" }
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ patch with params should be used with as: to specify a param encoding
    RUBY
  end

  def test_offense_with_post_when_params_and_missing_as
    assert_offense <<~RUBY
      post "/api/v1/user", params: { name: "Esteban" }
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ post with params should be used with as: to specify a param encoding
    RUBY
  end

  def test_offense_with_put_when_params_and_missing_as
    assert_offense <<~RUBY
      put "/api/v1/user", params: { name: "Esteban" }
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ put with params should be used with as: to specify a param encoding
    RUBY
  end

  def test_offense_with_dynamic_string_when_params_and_missing_as
    assert_offense <<~RUBY
      patch "/api/v1/user/\#{id}", params: { name: "Esteban" }
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ patch with params should be used with as: to specify a param encoding
    RUBY
  end

  def test_does_not_registers_offense_when_no_params
    assert_no_offenses <<~RUBY
      post "/api/v1/user"
    RUBY
  end

  def test_does_not_registers_offense_when_params_and_as
    assert_no_offenses <<~RUBY
      post "/api/v1/user", params: { name: "Esteban" }, as: :json
    RUBY
  end

  def test_does_not_registers_offense_with_get
    assert_no_offenses <<~RUBY
      get "/api/v1/user", params: { name: "Esteban" }
    RUBY
  end
end
