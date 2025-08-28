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

  context "vimspec style tests"

    it "runs file test for nearest"
      view +2 math.vimspec
      TestNearest
      messages

      Expect g:test#last_command == 'themis math.vimspec'

      view +7 math.vimspec
      TestNearest
      messages

      Expect g:test#last_command == "themis math.vimspec --target 'asserts 1 plus 1 equals 2'"

      view +11 math.vimspec
      TestNearest
      messages

      Expect g:test#last_command == "themis math.vimspec --target " . shellescape("doesn't \"break\" on ➕`?")
    end

    it "runs file tests"
      view +2 math.vimspec
      TestFile

      Expect g:test#last_command == 'themis math.vimspec'
    end

    it "runs test suite"
      view math.vimspec
      TestSuite

      Expect g:test#last_command == 'themis'
    end

    it "passes arguments before the file"
      view +2 math.vimspec
      TestFile --foo bar

      Expect g:test#last_command == 'themis --foo bar math.vimspec'
    end

  end

end
