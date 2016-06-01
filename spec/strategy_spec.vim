source spec/support/helpers.vim

describe "strategy"
  after
    call Teardown()
    unlet! g:strategy g:test#strategy
    let g:test#custom_strategies = {}
  end

  it "defaults to basic"
    function! test#strategy#basic(cmd)
      let g:strategy = 'basic'
    endfunction

    RSpec

    Expect g:strategy == 'basic'
  end

  it "can be set via test#strategy as built-in"
    function! test#strategy#neovim(cmd)
      let g:strategy = 'neovim'
    endfunction

    let g:test#strategy = 'neovim'
    RSpec

    Expect g:strategy == 'neovim'
  end

  it "can be set via test#strategy as custom"
    function! CustomStrategy(cmd)
      let g:strategy = 'custom'
    endfunction

    let g:test#custom_strategies = {'basic': function('CustomStrategy')}
    let g:test#strategy = 'basic'
    RSpec

    Expect g:strategy == 'custom'
  end

  it "can be set per command"
    function! test#strategy#neovim(cmd)
      let g:strategy = 'neovim'
    endfunction

    edit foo_spec.rb
    TestFile -strategy=neovim

    Expect g:strategy == 'neovim'
  end

  it "switches to VimScript regardless of the value"
    function! test#strategy#vimscript(cmd)
      let g:strategy = 'vimscript'
    endfunction

    let g:test#strategy = 'neovim'
    FireplaceTest

    Expect g:strategy == 'vimscript'
  end

  it "can be set for different granularities"
    function! test#strategy#basic(cmd)
      let g:strategy = 'basic'
    endfunction
    function! test#strategy#neovim(cmd)
      let g:strategy = 'neovim'
    endfunction

    let g:test#strategy = {'nearest': 'neovim', 'file': 'basic'}
    edit foo_spec.rb

    TestNearest
    Expect g:strategy == 'neovim'

    TestFile
    Expect g:strategy == 'basic'
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
