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
    Expect g:test#last_position['file'] ==# 'math_test.clj'

    view math_test.cljs | TestSuite
    Expect g:test#last_position['file'] ==# 'math_test.cljs'

    view test/math.clj | TestSuite
    Expect g:test#last_position['file'] ==# 'test/math.clj'

    view test/math.cljs | TestSuite
    Expect g:test#last_position['file'] ==# 'test/math.cljs'
  end

  it "runs nearest tests"
    view +7 math_test.clj
    TestNearest
    Expect g:test#last_command ==# "lein test :only 'math-test/+-works'"

    view +10 math_test.clj
    TestNearest
    Expect g:test#last_command ==# "lein test :only 'math-test/*-works'"

    view +13 math_test.clj
    TestNearest
    Expect g:test#last_command ==# "lein test :only 'math-test/+-is-commutative'"

    view +18 math_test.clj
    TestNearest
    Expect g:test#last_command ==# "lein test :only 'math-test/*-is-commutative'"
  end

  it "runs file tests"
    view math_test.clj
    TestFile

    Expect g:test#last_command ==# "lein test :only 'math-test'"
  end

  it "runs test suites"
    view math_test.clj
    TestSuite

    Expect g:test#last_command ==# 'lein test :all'
  end
end
