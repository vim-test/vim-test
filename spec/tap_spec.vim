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

    Expect g:test#last_command == "tap tests/normal.js --grep='math test'"

    view +3 tests/subtest.js
    TestNearest

    Expect g:test#last_command == "tap tests/subtest.js --grep='parent'"

    view +4 tests/subtest.js
    TestNearest

    Expect g:test#last_command == "tap tests/subtest.js --grep='subtest'"
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

  it "also recognizes test/ directory"
    view test/normal.js
    TestFile

    Expect g:test#last_command == 'tap test/normal.js'
  end


  it "runs file tests ending in .test.js"
    view src/normal.test.js
    TestFile

    Expect g:test#last_command == 'tap src/normal.test.js'
  end

  it "runs file tests ending in .spec.js"
    !cp src/normal.test.js src/normal.spec.js
    view src/normal.spec.js
    TestFile
    !rm src/normal.spec.js

    Expect g:test#last_command == 'tap src/normal.spec.js'
  end
end
