source spec/support/helpers.vim

describe "elm-test"
  before
    cd spec/fixtures/elmtest
  end

  after
    call Teardown()
    cd -
  end

  it "runs file for nearest tests"
    view tests/NormalTest.elm
    TestNearest

    Expect TestNormalizeCommand(g:test#last_command) == 'elm-test tests/NormalTest.elm'
  end

  it "runs file tests"
    view tests/NormalTest.elm
    TestFile

    Expect TestNormalizeCommand(g:test#last_command) == 'elm-test tests/NormalTest.elm'
  end

  it "runs test suites"
    view tests/NormalTest.elm
    TestSuite

    Expect g:test#last_command == 'elm-test'
  end

  it "runs tests against absolute path of npm executable (elm-test)"
    try
      call CreateNodeBin('elm-test')

      view tests/NormalTest.elm
      TestFile

      Expect TestNormalizeCommand(g:test#last_command) == 'node_modules/.bin/elm-test tests/NormalTest.elm'
    finally
      call TeardownNodeBinDir()
    endtry
  end

  it "runs tests against absolute path of npm executable (elm-test and elm-compiler)"
    try
      call CreateNodeBin('elm-test')
      call CreateNodeBin('elm')

      view tests/NormalTest.elm
      TestFile

      Expect TestNormalizeCommand(g:test#last_command) == 'node_modules/.bin/elm-test --compiler node_modules/.bin/elm tests/NormalTest.elm'
    finally
      call TeardownNodeBinDir()
    endtry
  end
end
