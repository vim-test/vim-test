source test/helpers.vim

describe 'Running'

  after
    call Teardown()
  end

  it "remembers the last test file position"
    edit foo_spec.rb
    edit foo.txt

    TestNearest
    Expect g:test#last_command == 'rspec foo_spec.rb:1'

    TestFile
    Expect g:test#last_command == 'rspec foo_spec.rb'

    TestSuite
    Expect g:test#last_command == 'rspec'
  end

  it "runs last test"
    edit foo_spec.rb
    TestNearest

    edit bar_spec.rb
    TestLast

    Expect g:test#last_command == 'rspec foo_spec.rb:1'
  end

  it "doesn't raise an error when unable to run tests"
    edit foo.txt
    TestNearest | TestFile | TestSuite | TestLast
  end

  it "picks a user defined test#{runner}#executable"
    let g:test#rspec#executable = 'foo'

    edit foo_spec.rb
    TestFile

    Expect g:test#last_command == 'foo foo_spec.rb'

    unlet g:test#rspec#executable
  end

end
