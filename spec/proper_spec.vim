source spec/support/helpers.vim

describe 'PropEr'
  before
    cd spec/fixtures/proper
  end

  after
    call Teardown()
    cd -
  end

  context 'when executed with :TestFile'
    it 'runs properties for corresponding module'
      view test/prop_foo.erl
      TestFile

      Expect g:test#last_command is# 'rebar3 proper --module=prop_foo'
    end
  end

  context 'when executed with :TestNearest'
    it 'runs the property under the cursor'
      view +/prop_bar test/prop_foo.erl
      TestNearest

      Expect g:test#last_command is# 'rebar3 proper --module=prop_foo --prop=prop_bar'

      view +/prop_baz/+1 test/prop_foo.erl
      TestNearest

      Expect g:test#last_command is# 'rebar3 proper --module=prop_foo --prop=prop_baz'
    end

    context 'when there is no property under the cursor'
      it 'runs properties for corresponding module'
        view +1 test/prop_foo.erl
        TestNearest

        Expect g:test#last_command is# 'rebar3 proper --module=prop_foo'
      end
    end
  end

  context 'when executed with :TestSuite'
    it 'runs all property test suites'
      view test/prop_foo.erl
      TestSuite

      Expect g:test#last_command is# 'rebar3 proper'
    end
  end
end
