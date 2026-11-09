source spec/support/helpers.vim

describe "TAP"

  before
    cd spec/fixtures/tap
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest test"
    view +6 tests/normal.js
    TestNearest

    Expect g:test#last_command == "tap tests/normal.js --grep='this is a child test'"

    view +5 tests/subtest.js
    TestNearest

    Expect g:test#last_command == "tap tests/subtest.js --grep='test myObject'"

    view +6 tests/subtest.js
    TestNearest

    Expect g:test#last_command == "tap tests/subtest.js --grep='nested child test'"
  end

  it "runs file tests"
    view tests/normal.js
    TestFile

    Expect g:test#last_command == 'tap tests/normal.js'
  end

  it "runs test suites"
    view tests/normal.js
    TestSuite

    Expect g:test#last_command == 'tap'
  end
end
