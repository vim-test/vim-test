require "minitest/autorun"

module Math
  class TestNumbers < Minitest::Test
    def self.test(name, &block)
      test_name = "test_#{name.gsub(/\s+/, '_')}".to_sym
      define_method(test_name) do
        instance_eval(&block) if block_given?
      end
    end

    def test_method
      assert 1 == 1
    end

    test "double quotes" do
      assert 1 == 1
    end

    test 'single quotes' do
      assert 1 == 1
    end

    test "single quote ' inside" do
      assert 1 == 1
    end

    test 'double quote " inside' do
      assert 1 == 1
    end

    test "pending test"
  end
end
