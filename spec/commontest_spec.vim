source spec/support/helpers.vim

describe "CommonTest"

  before
    cd spec/fixtures/commontest
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests"
    view test_SUITE.erl
    TestFile

    Expect g:test#last_command == 'rebar3 ct --suite=test_SUITE.erl'
  end

  it "runs nearest tests"
    view +1 test_SUITE.erl
    TestNearest

    Expect g:test#last_command == "rebar3 ct --suite=test_SUITE.erl"

    view +54 test_SUITE.erl
    TestNearest

    Expect g:test#last_command == "rebar3 ct --suite=test_SUITE.erl --case=test_1"

    view +57 test_SUITE.erl
    TestNearest

    Expect g:test#last_command == "rebar3 ct --suite=test_SUITE.erl --case=test_2"

    view +60 test_SUITE.erl
    TestNearest

    Expect g:test#last_command == "rebar3 ct --suite=test_SUITE.erl --case=test_3"
  end

  it "runs test suites"
    view test_SUITE.erl
    TestSuite

    Expect g:test#last_command == 'rebar3 ct'
  end

  it "doesn't recognize files that don't end with '_SUITE.erl'"
    view test.erl
    TestFile

    Expect exists('g:test#last_command') == 0
  end

end
