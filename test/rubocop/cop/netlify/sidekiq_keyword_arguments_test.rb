# frozen_string_literal: true

require 'test_helper'

class SidekiqKeywordArgumentsTest < Minitest::Test
  def test_offense_with_only_keyword_arguments
    assert_offense <<~RUBY
      class Worker
        def perform(user_id:, update: true)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid keyword arguments in workers
          puts user_id
        end
      end
    RUBY
  end

  def test_offense_with_trailing_keyword_arguments
    assert_offense <<~RUBY
      class Worker
        def perform(user_id, update:, name:)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid keyword arguments in workers
          puts user_id
        end
      end
    RUBY
  end

  def test_offense_with_keyword_arguments_defaults
    assert_offense <<~RUBY
      class Worker
        def perform(user_id, update: true)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid keyword arguments in workers
          puts user_id
        end
      end
    RUBY
  end

  def test_no_offense_with_regular_arguments
    assert_no_offenses <<~RUBY
      class Worker
        def perform(user_id, update = {})
          puts user_id
        end
      end
    RUBY
  end
end
