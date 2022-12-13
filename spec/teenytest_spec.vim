source spec/support/helpers.vim

describe "Teenytest"

  before
    let g:test#javascript#runner = 'teenytest'
    cd spec/fixtures/teenytest
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest test"
    view +1 test/normal.js
    TestNearest

    Expect g:test#last_command == 'teenytest test/normal.js:1'
  end

  it "runs file tests"
    view test/normal.js
    TestFile

    Expect g:test#last_command == 'teenytest test/normal.js'
  end

  it "runs test suites"
    view test/normal.js
    TestSuite

    Expect g:test#last_command == 'teenytest'
  end

  it "also recognizes tests/ directory"
    try
      !mv test tests
      view tests/normal.js
      TestFile

      Expect g:test#last_command == 'teenytest tests/normal.js'
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
