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
    view +1 test/lib/dog-test.js
    TestNearest

    Expect g:test#last_command == 'teenytest test/lib/dog-test.js:1'
  end

  it "runs file tests"
    view test/lib/dog-test.js
    TestFile

    Expect g:test#last_command == 'teenytest test/lib/dog-test.js'
  end

  it "runs test suites"
    view test/lib/dog-test.js
    TestSuite

    Expect g:test#last_command == 'teenytest'
  end

  it "also recognizes tests/ directory"
    try
      !mv test tests
      view tests/lib/dog-test.js
      TestFile

      Expect g:test#last_command == 'teenytest tests/lib/dog-test.js'
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
