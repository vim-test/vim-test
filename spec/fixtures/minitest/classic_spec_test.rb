require "minitest/autorun"
require "minitest/spec"

TestNumbers = Class.new

describe "Math" do
  describe TestNumbers do
    it "has double quotes" do
      assert 1 == 1
    end

    it 'has single quotes' do
      assert 1 == 1
    end

    it "contains a '" do
      assert 1 == 1
    end

    it 'contains a "' do
      assert 1 == 1
    end

    it "contains `backticks`" do
      assert 1 == 1
    end

    it "is pending"

    it("has parentheses") {}

    describe("Parentheses") {}
  end
end

module Math
  Numbers = Class.new

  describe Numbers do
    it "is" do
      assert 1 == 1
    end
  end

  describe "Numbers" do
    it "is" do
      assert 1 == 1
    end
  end
end
