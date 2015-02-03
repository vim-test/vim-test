source spec/helpers.vim

describe 'Options'

  after
    call Teardown()
  end

  it "is forwarded through generic testing commands"
    edit foo_spec.rb

    TestNearest --foo bar --baz
    Expect g:test#last_command == 'rspec --foo bar --baz foo_spec.rb:1'

    TestFile --foo bar --baz
    Expect g:test#last_command == 'rspec --foo bar --baz foo_spec.rb'

    TestSuite --foo bar --baz
    Expect g:test#last_command == 'rspec --foo bar --baz'
  end

  it "goes through specific testing commands"
    edit foo_spec.rb

    RSpec --foo bar --baz
    Expect g:test#last_command == 'rspec --foo bar --baz'
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
  end

end
