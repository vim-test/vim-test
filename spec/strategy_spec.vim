source spec/support/helpers.vim

describe "strategy"
  before
    source spec/support/test/strategy.vim
    cd spec/fixtures/rspec-other
  end

  after
    call Teardown()
    cd -
    unlet! g:test#strategy
    let g:test#custom_strategies = {}
  end

  it "defaults to basic"
    view spec/normal_spec.rb

    TestFile

    Expect g:test#last_strategy == 'basic'
  end

  it "can be set via test#strategy as built-in"
    let g:test#strategy = 'neovim'
    view spec/normal_spec.rb

    TestFile

    Expect g:test#last_strategy == 'neovim'
  end

  it "can be set via test#strategy as custom"
    function! CustomStrategy(cmd)
    endfunction
    let g:test#custom_strategies = {'custom': function('CustomStrategy')}
    let g:test#strategy = 'custom'
    view spec/normal_spec.rb

    TestFile

    Expect g:test#last_strategy == 'custom'
  end

  it "can be set per command"
    let g:test#strategy = 'foo'

    view spec/normal_spec.rb
    TestSuite -strategy=neovim

    Expect g:test#last_strategy == 'neovim'
    Expect g:test#last_command == 'rspec'

    view spec/normal_spec.rb
    TestFile -strategy=dispatch

    Expect g:test#last_strategy == 'dispatch'
    Expect g:test#last_command == 'rspec spec/normal_spec.rb'

    TestLast -strategy=basic

    Expect g:test#last_strategy == 'basic'
    Expect g:test#last_command == 'rspec spec/normal_spec.rb'
  end

  it "remembers strategy passed when running last test"
    view spec/normal_spec.rb
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

    view spec/normal_spec.rb

    TestNearest
    Expect g:test#last_strategy == 'neovim'

    TestFile
    Expect g:test#last_strategy == 'basic'

    TestSuite
    Expect g:test#last_strategy == 'dispatch'
  end
end
