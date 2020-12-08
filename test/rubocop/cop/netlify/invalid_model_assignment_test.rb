# frozen_string_literal: true

require 'test_helper'

class InvalidModelAssignmentTest < Minitest::Test
  def test_offense_with_model_assignment
    assert_offense <<~RUBY
      class User
        attr_reader :attributes
      end
      user = User.new
      user.attributes[:email] = \"test@example.com\"
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Assigning to `attributes` will not update record
    RUBY
  end

  def test_does_not_registers_offense_reading
    assert_no_offenses <<~RUBY
      class User
        attr_reader :attributes
      end
      user = User.new
      puts user.attributes
    RUBY
  end

  def test_does_not_registers_offense_with_variable
    assert_no_offenses <<~RUBY
      attributes = {}
      attributes[:email] = "test@example.com"
      puts attributes
    RUBY
  end
end
