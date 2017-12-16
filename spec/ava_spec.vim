source spec/support/helpers.vim

describe "Ava"

  before
    let g:test#javascript#runner = 'ava'
    cd spec/fixtures/ava
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest test"
    view +1 test/normal.js
    TestNearest

    Expect g:test#last_command == 'ava test/normal.js --match=''Adds two numbers'''
  end

  it "runs file test if nearest test couldn't be found"
    view +1 test/normal.js
    normal O
    TestNearest

    Expect g:test#last_command == 'ava test/normal.js'
  end

  it "runs file tests"
    view test/normal.js
    TestFile

    Expect g:test#last_command == 'ava test/normal.js'
  end

  it "runs test suites"
    view test/normal.js
    TestSuite

    Expect g:test#last_command == 'ava'
  end

  it "also recognizes tests/ directory"
    try
      !mv test tests
      view tests/normal.js
      TestFile

      Expect g:test#last_command == 'ava tests/normal.js'
    finally
      !mv tests test
    endtry
  end

  it "doesn't detect JavaScripts which are not in the test/ folder"
    view outside.js
    TestSuite

    Expect exists('g:test#last_command') == 0
  end

end
