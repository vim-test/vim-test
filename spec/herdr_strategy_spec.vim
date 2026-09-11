source spec/support/helpers.vim

describe "herdr strategy"
  after
    delfunction! HerdrStrategy
    unlet! g:herdr_command
  end

  it "delegates to vim-test-herdr"
    function! HerdrStrategy(cmd) abort
      let g:herdr_command = a:cmd
    endfunction

    call test#strategy#herdr('echo test')

    Expect g:herdr_command == 'echo test'
  end
end
