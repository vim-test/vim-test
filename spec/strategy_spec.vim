source spec/support/helpers.vim

describe "strategy"
  before
    source spec/support/test/strategy.vim
  end

  after
    call Teardown()
    unlet! g:test#strategy
    let g:test#custom_strategies = {}
  end

  it "defaults to basic"
    RSpec

    Expect g:test#last_strategy == 'basic'
  end

  it "can be set via test#strategy as built-in"
    let g:test#strategy = 'neovim'

    RSpec

    Expect g:test#last_strategy == 'neovim'
  end

  it "can be set via test#strategy as custom"
    function! CustomStrategy(cmd)
    endfunction
    let g:test#custom_strategies = {'custom': function('CustomStrategy')}
    let g:test#strategy = 'custom'

    RSpec

    Expect g:test#last_strategy == 'custom'
  end

  it "can be set per command"
    let g:test#strategy = 'foo'

    RSpec -strategy=neovim

    Expect g:test#last_strategy == 'neovim'
    Expect g:test#last_command == 'rspec'

    edit foo_spec.rb
    TestFile -strategy=dispatch

    Expect g:test#last_strategy == 'dispatch'
    Expect g:test#last_command == 'rspec foo_spec.rb'

    TestLast -strategy=basic

    Expect g:test#last_strategy == 'basic'
    Expect g:test#last_command == 'rspec foo_spec.rb'
  end

  it "remembers strategy passed when running last test"
    edit foo_spec.rb
    TestNearest

    TestLast -strategy=neovim
    Expect g:test#last_strategy == 'neovim'

    TestLast
    Expect g:test#last_strategy == 'neovim'

    TestLast -strategy=basic
    Expect g:test#last_strategy == 'basic'
  end

  it "can be set for different granularities"
    let g:test#strategy = {'nearest': 'neovim', 'suite': 'dispatch'}

    edit foo_spec.rb

    TestNearest
    Expect g:test#last_strategy == 'neovim'

    TestFile
    Expect g:test#last_strategy == 'basic'

    TestSuite
    Expect g:test#last_strategy == 'dispatch'
  end

  it "switches to VimScript regardless of the value"
    function! test#strategy#vimscript(cmd)
      let g:vimscript_called = 1
    endfunction
    let g:test#strategy = 'neovim'

    FireplaceTest

    Expect g:vimscript_called == 1

    unlet g:vimscript_called
  end
end
