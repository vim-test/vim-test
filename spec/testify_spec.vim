source spec/support/helpers.vim
runtime! plugin/vim-testify

describe "Testify"

  before
    let g:test#enabled_runners = ['viml#testify']
    cd spec/fixtures/testify
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +3 test/normal.vim
    TestNearest

    Expect g:test#last_command == ':TestifyNearest'
  end

  it "runs file tests"
    view test/normal.vim
    TestFile

    Expect g:test#last_command == ':TestifyFile'
  end

  it "runs test suites"
    view test/normal.vim
    TestSuite

    Expect g:test#last_command == ':TestifySuite'
  end

  it "detects test folders"
    try
      view test/normal.vim
      TestSuite

      Expect g:test#last_command == ':TestifySuite'

      !mv test t
      TestSuite

      Expect g:test#last_command == ':TestifySuite'

      !mv t spec
      TestSuite

      Expect g:test#last_command == ':TestifySuite'
    finally
      !mv spec test
    endtry
  end

end
