class TestNumbers < Minitest::Test
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
