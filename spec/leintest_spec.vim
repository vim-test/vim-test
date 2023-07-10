source spec/support/helpers.vim

describe "LeinTest"

  before
    let g:test#clojure#runner = 'leintest'
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
  end

  it "runs nearest tests"
    view +3 math_test.clj
    TestNearest

    Expect g:test#last_command =~# 'lein test :only math-test/a-test'
  end

  it "runs file tests"
    view math_test.clj
    TestFile

    Expect g:test#last_command =~# 'lein test :only math-test'
  end

  it "runs test suites"
    view math_test.clj
    TestSuite

    Expect g:test#last_command =~# 'lein test :all'
  end
end
