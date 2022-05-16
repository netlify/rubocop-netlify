# frozen_string_literal: true

require 'test_helper'

class RailsEnvCheckTest < Minitest::Test
  def test_offense_with_rails_production
    assert_offense <<~RUBY
      if Rails.env.production?; end
         ^^^^^^^^^^^^^^^^^^^^^ Prefer using `Netlify.env` instead of `Rails.env` to check the environment
    RUBY
  end

  def test_offense_with_rails_staging
    assert_offense <<~RUBY
      if Rails.env.staging?; end
         ^^^^^^^^^^^^^^^^^^ Prefer using `Netlify.env` instead of `Rails.env` to check the environment
    RUBY
  end

  def test_does_not_registers_offense_reading
    assert_no_offenses <<~RUBY
        if Rails.env.test?; end
    RUBY
  end
end
