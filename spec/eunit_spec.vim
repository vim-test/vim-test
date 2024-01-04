source spec/support/helpers.vim

describe 'EUnit'
  before
    cd spec/fixtures/eunit
  end

  after
    call Teardown()
    cd -
  end

  context 'when executed with :TestFile'
    it 'runs tests for corresponding module'
      view example_tests.erl
      TestFile

      Expect g:test#last_command is# 'rebar3 eunit --module=example_tests'
    end
  end

  context 'when executed with :TestNearest'
    it 'runs the test under the cursor'
      view +/simple_test/+1 example_tests.erl
      TestNearest

      Expect g:test#last_command is# 'rebar3 eunit --test=example_tests:simple_test'
    end

    it 'runs tests from the generator under the cursor'
      view +/generator_test_/+1 example_tests.erl
      TestNearest

      Expect g:test#last_command is# 'rebar3 eunit --generator=example_tests:generator_test_'
    end

    context 'when there is no test or generator under the cursor'
      it 'runs tests for corresponding module'
        view +1 example_tests.erl
        TestNearest

        Expect g:test#last_command is# 'rebar3 eunit --module=example_tests'
      end
    end
  end

  context 'when executed with :TestSuite'
    it 'runs all test suites'
      view example_tests.erl
      TestSuite

      Expect g:test#last_command is# 'rebar3 eunit'
    end
  end

  it 'ignores files not ending with _tests.erl'
    view example_SUITE.erl
    TestFile

    Expect g:test#last_command !~# 'rebar3 eunit'

    view example.erl
    TestFile

    Expect g:test#last_command !~# 'rebar3 eunit'
  end
end
