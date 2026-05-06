source spec/support/helpers.vim

describe "Zig"

  before
    cd spec/fixtures/zig
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests"
    view normal.zig
    TestFile

    Expect g:test#last_command == "zig test normal.zig"
  end

  it "runs nearest test above"
    view +9 normal.zig
    TestNearest

    Expect g:test#last_command == 'zig test normal.zig --test-filter ''numbers 2'''
  end

  it "runs nearest test below"
    view +1 normal.zig
    TestNearest

    Expect g:test#last_command == 'zig test normal.zig --test-filter ''numbers'''
  end

  it "runs test with an identifier as a name"
    view +13 normal.zig
    TestNearest

    Expect g:test#last_command == 'zig test normal.zig --test-filter ''addOne'''
  end

  it "runs all tests"
    view normal.zig
    TestSuite

    Expect g:test#last_command == "zig build test"
  end

  it "update g:test#last_position with exact line of the test"
    view +1 normal.zig
    TestNearest

    Expect g:test#last_position['line'] == 4

    view +9 normal.zig
    TestNearest

    Expect g:test#last_position['line'] == 8
end
