source spec/helpers.vim

describe "VSpec"

  before
    cd spec/fixtures/vspec
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests instead of nearest tests"
    view +1 test/normal.vim
    TestNearest

    Expect LastCommand() == 'vim-flavor test test/normal.vim'
  end

  it "runs file tests"
    view test/normal.vim
    TestFile

    Expect LastCommand() == 'vim-flavor test test/normal.vim'
  end

  it "runs test suites"
    view test/normal.vim
    TestSuite

    Expect LastCommand() == 'vim-flavor test test/'
  end

  it "doesn't recognize vim files outside of test foder"
    view outside.vim
    TestFile

    Expect exists('g:test#last_command') == 0
  end

  it "detects test folders"
    try
      view test/normal.vim
      TestSuite

      Expect LastCommand() == 'vim-flavor test test/'

      !mv test t
      view t/normal.vim
      TestSuite

      Expect LastCommand() == 'vim-flavor test t/'

      !mv t spec
      view spec/normal.vim
      TestSuite

      Expect LastCommand() == 'vim-flavor test spec/'
    finally
      !mv spec test
    endtry
  end

end
