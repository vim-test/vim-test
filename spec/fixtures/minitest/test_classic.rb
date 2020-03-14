require "minitest/autorun"

module Math
  class TestOperators < Minitest::Test
    def test_addition
      assert 1 + 1 == 2
    end
  end
end
