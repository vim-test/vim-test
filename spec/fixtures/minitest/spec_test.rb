require "minitest/autorun"

class TestNumbers
end

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

    it "is pending"
  end
end
