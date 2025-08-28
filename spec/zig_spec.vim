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

  it "runs nearest test"
    view +9 normal.zig
    TestNearest

    Expect g:test#last_command == 'zig test normal.zig --test-filter ''numbers 2'''
  end

  it "runs all tests"
    view normal.zig
    TestSuite

    Expect g:test#last_command == "zig build test"
  end
end
