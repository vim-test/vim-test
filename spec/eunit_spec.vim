source spec/support/helpers.vim

describe "EUnit"

  before
    cd spec/fixtures/eunit
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests"
    view example_tests.erl
    TestFile

    Expect g:test#last_command == 'rebar3 eunit --module=example_tests'
  end

  it "runs file tests instead of nearest tests"
    view +8 example_tests.erl
    TestNearest

    Expect g:test#last_command == 'rebar3 eunit --module=example_tests'
  end

  it "runs test suites"
    view example_tests.erl
    TestSuite

    Expect g:test#last_command == 'rebar3 eunit'
  end

  it "ignores files not ending with _tests.erl"
    view example_SUITE.erl
    TestFile

    Expect g:test#last_command !~# 'rebar3 eunit'

    view example.erl
    TestFile

    Expect g:test#last_command !~# 'rebar3 eunit'
  end
end
