source spec/support/helpers.vim
runtime! plugin/vim-themis

describe "Themis"

  before
    cd spec/fixtures/themis
  end

  after
    call Teardown()
    cd -
  end

  it "runs file test for nearest"
    view +2 math.vim
    TestNearest
    messages

    Expect g:test#last_command == 'themis math.vim'
  end

  it "runs file tests"
    view +2 math.vim
    TestFile

    Expect g:test#last_command == 'themis math.vim'
  end

  it "runs test suite"
    view math.vim
    TestSuite

    Expect g:test#last_command == 'themis'
  end

  it "passes arguments before the file"
    view +2 math.vim
    TestFile --foo bar

    Expect g:test#last_command == 'themis --foo bar math.vim'
  end

end
