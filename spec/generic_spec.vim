source spec/support/helpers.vim

function s:expect_root() abort
  Expect g:test#last_command == "echo 'root spec'"
endfunction

function s:expect_override() abort
  Expect g:test#last_command == "echo 'override spec'"
endfunction

describe 'Generic runner'
  before
    cd spec/fixtures/generic
  end

  after
    call Teardown()
    cd -
  end

  it 'runs command from opened vimtest.json'
    view .vimtest.json
    for l:command in [ 'TestFile', 'TestSuite', 'TestClass', 'TestNearest' ]
      execute l:command
      call s:expect_root()
    endfor
  end

  it 'runs command from vimtest.json in same directory'
    view readme.md
    for l:command in [ 'TestFile', 'TestSuite', 'TestClass', 'TestNearest' ]
      execute l:command
      call s:expect_root()
    endfor
  end

  it 'runs command from vimtest.json in parent directory'
    view nooverride/readme.md
    TestFile
    call s:expect_root()
  end

  it 'runs command from closest vimtest.json'
    view override/readme.md
    TestFile
    call s:expect_override()
  end
end

