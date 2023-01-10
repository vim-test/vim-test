source spec/support/helpers.vim

describe 'Options'

  after
    call Teardown()
  end

  it "is forwarded through generic testing commands"
    edit foo_spec.rb

    TestNearest --foo bar
    Expect g:test#last_command == 'rspec --foo bar foo_spec.rb:1'

    TestFile --foo bar
    Expect g:test#last_command == 'rspec --foo bar foo_spec.rb'

    TestSuite --foo bar
    Expect g:test#last_command == 'rspec --foo bar'

    TestLast --baz
    Expect g:test#last_command == 'rspec --foo bar --baz'

    TestLast
    Expect g:test#last_command == 'rspec --foo bar --baz'
  end

  it "remembers options passed when running last test"
    edit foo_spec.rb
    TestNearest

    TestLast --foo
    Expect g:test#last_command == 'rspec foo_spec.rb:1 --foo'

    TestLast
    Expect g:test#last_command == 'rspec foo_spec.rb:1 --foo'
  end

  it "goes through specific testing commands"
    edit foo_spec.rb

    RSpec --foo bar --baz
    Expect g:test#last_command == 'rspec --foo bar --baz'
  end

  it "supports passing environment variables"
    edit foo_spec.rb

    TestFile -foo VARIABLE=value --bar baz
    Expect g:test#last_command == 'VARIABLE=value rspec -foo --bar baz foo_spec.rb'

    TestLast SETTING=value
    Expect g:test#last_command == 'SETTING=value VARIABLE=value rspec -foo --bar baz foo_spec.rb'
  end

  describe "g:test#{runner}#options"
    after
      unlet g:test#ruby#rspec#options
    end

    it "goes through each run as a string"
      let g:test#ruby#rspec#options = '--foo bar --baz'
      new foo_spec.rb

      TestNearest
      Expect g:test#last_command == 'rspec --foo bar --baz foo_spec.rb:1'

      TestFile
      Expect g:test#last_command == 'rspec --foo bar --baz foo_spec.rb'

      TestSuite
      Expect g:test#last_command == 'rspec --foo bar --baz'
    end

    it "goes through specific granularities as a dictionary"
      let g:test#ruby#rspec#options = {
        \ 'nearest': '--nearest',
        \ 'file':    '--file',
      \}
      new foo_spec.rb

      TestNearest
      Expect g:test#last_command == 'rspec --nearest foo_spec.rb:1'

      TestFile
      Expect g:test#last_command == 'rspec --file foo_spec.rb'

      TestSuite
      Expect g:test#last_command == 'rspec'
    end

    it "allows a global option to be set along with specific granularities"
      let g:test#ruby#rspec#options = {
        \ 'all':  '--foo bar',
        \ 'file': '--baz',
      \}
      new foo_spec.rb

      TestNearest
      Expect g:test#last_command == 'rspec --foo bar foo_spec.rb:1'

      TestSuite
      Expect g:test#last_command == 'rspec --foo bar'

      TestFile
      Expect g:test#last_command == 'rspec --foo bar --baz foo_spec.rb'
    end
  end

end
