source spec/support/helpers.vim

describe 'Main'

  after
    call Teardown()
  end

  it "runs tests on different granularities"
    edit foo_spec.rb

    TestNearest
    Expect g:test#last_command == 'rspec foo_spec.rb:1'

    TestFile
    Expect g:test#last_command == 'rspec foo_spec.rb'

    TestSuite
    Expect g:test#last_command == 'rspec'
  end

  it "remembers the last test-run position when not on test file"
    edit foo_spec.rb
    TestFile

    edit foo.txt
    TestFile

    Expect g:test#last_command == 'rspec foo_spec.rb'
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
    let g:test#ruby#rspec#executable = 'foo'

    edit foo_spec.rb
    TestFile

    Expect g:test#last_command == 'foo foo_spec.rb'

    unlet g:test#ruby#rspec#executable
  end

  it "can go to the last run test"
    edit +3 spec/commands_spec.vim
    TestNearest

    edit foo.txt
    TestVisit

    Expect expand('%') == 'spec/commands_spec.vim'
    Expect line('.') == 3
  end

  it "generates paths according to the filename modifier"
    let g:test#filename_modifier = ':p'

    view foo_spec.rb
    TestFile

    Expect g:test#last_command == 'rspec '.getcwd().'/foo_spec.rb'

    unlet g:test#filename_modifier
  end
end

describe "transformation"
  after
    call Teardown()
    unlet! g:transformation g:test#transformation
    let g:test#custom_transformations = {}
  end

  it "can be set via test#transformation"
    function! EchoTransformation(cmd)
      return 'echo'
    endfunction

    function! test#strategy#basic(cmd)
      let g:transformation = a:cmd
    endfunction

    let g:test#custom_transformations = {'echo': function('EchoTransformation')}
    let g:test#transformation = 'echo'
    RSpec

    Expect g:transformation == 'echo'
  end
end
