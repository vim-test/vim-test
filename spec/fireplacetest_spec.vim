source spec/helpers.vim
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
    view +5 math_test.clj
    TestNearest

    Expect g:test#last_command =~# '\V(clojure.test/test-vars [#''math-test/a-test])'

    view +9 math_test.clj
    TestNearest

    Expect g:test#last_command =~# '\V(clojure.test/test-vars [#''math-test/another-test])'
  end

  it "falls back to file test if nearest test wasn't found"
    view +1 math_test.clj
    TestNearest

    Expect g:test#last_command =~# '(clojure.test/run-tests ''math-test)'
  end

  it "runs file tests"
    view math_test.clj
    TestFile

    Expect g:test#last_command =~# '(clojure.test/run-tests ''math-test)'
  end

  it "runs test suites"
    view math_test.clj
    TestSuite

    Expect g:test#last_command =~# '(clojure.test/run-all-tests)'
  end

  describe "command"

    it "runs all tests without arguments"
      view math_test.clj
      FireplaceTest

      Expect g:test#last_command =~# '(clojure.test/run-all-tests)'
    end

    it "accepts regular expressions"
      view math_test.clj
      FireplaceTest /foo/

      Expect g:test#last_command =~# '(clojure.test/run-all-tests #\\"foo\\")'
    end

    it "accepts list of filenames, which it translates to namespaces"
      view math_test.clj
      FireplaceTest math_test.clj

      Expect g:test#last_command =~# '(clojure.test/run-tests ''math-test)'
    end

  end

end
