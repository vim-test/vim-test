source spec/support/helpers.vim

describe 'CommonTest'
  before
    cd spec/fixtures/commontest
  end

  after
    call Teardown()
    cd -
  end

  context 'when executed with :TestFile'
    it 'runs test cases for corresponding test suite module'
      view test_SUITE.erl
      TestFile

      Expect g:test#last_command is# 'rebar3 ct --suite=test_SUITE.erl'
    end
  end

  context 'when executed with :TestNearest'
    it 'runs the function prefixed with t_ under the cursor as a test case'
      view +/^t_foo/+1 test_SUITE.erl
      TestNearest

      Expect g:test#last_command is# 'rebar3 ct --suite=test_SUITE.erl --case=t_foo'
    end

    it 'runs the function prefixed with test_ under the cursor as a test case'
      view +/^test_foo/+1 test_SUITE.erl
      TestNearest

      Expect g:test#last_command is# 'rebar3 ct --suite=test_SUITE.erl --case=test_foo'
    end

    context 'when there is no test case under the cursor'
      it 'runs test cases for corresponding test suite module'
        view +1 test_SUITE.erl
        TestNearest

        Expect g:test#last_command is# 'rebar3 ct --suite=test_SUITE.erl'
      end
    end
  end

  context 'when executed with :TestSuite'
    it 'runs test cases for all test suite modules'
      view test_SUITE.erl
      TestSuite

      Expect g:test#last_command is# 'rebar3 ct'
    end
  end

  it 'ignores files not ending with _SUITE.erl'
    view test.erl
    TestFile

    Expect exists('g:test#last_command') == 0

    view example_tests.erl
    TestFile

    Expect g:test#last_command !~# 'rebar3 ct'
  end
end
