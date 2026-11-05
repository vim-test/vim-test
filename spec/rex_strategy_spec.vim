source spec/support/helpers.vim

describe "rex strategy"
  after
    delfunction! RexStrategy
    unlet! g:rex_command
  end

  it "delegates to vim-test-rex"
    function! RexStrategy(cmd) abort
      let g:rex_command = a:cmd
    endfunction

    call test#strategy#rex('echo test')

    Expect g:rex_command == 'echo test'
  end
end
