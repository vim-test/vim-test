source spec/support/helpers.vim
runtime! plugin/fireplace.vim

describe "FireplaceTest"

  before
    cd spec/fixtures/clojure
  end

  after
    call Teardown()
    cd -
  end

  it "recognizes test files"
    view math_test.clj | TestSuite
    Expect g:test#last_position['file'] == 'math_test.clj'

    view math_test.cljs | TestSuite
    Expect g:test#last_position['file'] == 'math_test.cljs'

    view test/math.clj | TestSuite
    Expect g:test#last_position['file'] == 'test/math.clj'

    view test/math.cljs | TestSuite
    Expect g:test#last_position['file'] == 'test/math.cljs'

    view math.clj | TestSuite
    Expect g:test#last_position['file'] != 'math.clj'
  end

  it "runs nearest tests"
    view +1 math_test.clj
    TestNearest

    Expect g:test#last_command =~# ':.RunTests'

    view foo.clj
    TestNearest

    Expect g:test#last_command =~# ':edit +1 math_test.clj | :.RunTests'
  end

  it "runs file tests"
    view math_test.clj
    TestFile

    Expect g:test#last_command =~# ':RunTests math-test'
  end

  it "runs test suites"
    view math_test.clj
    TestSuite

    Expect g:test#last_command =~# ':0RunTests'
  end

  it "passes arguments of raw command to :RunTests"
    FireplaceTest foo bar

    Expect g:test#last_command =~# ':RunTests foo bar'
  end

end
