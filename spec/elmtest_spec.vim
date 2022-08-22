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

    Expect g:test#last_command == 'elm-test tests/NormalTest.elm'
  end

  it "runs file tests"
    view tests/NormalTest.elm
    TestFile

    Expect g:test#last_command == 'elm-test tests/NormalTest.elm'
  end

  it "runs test suites"
    view tests/NormalTest.elm
    TestSuite

    Expect g:test#last_command == 'elm-test'
  end

  it "runs tests against absolute path of npm executable (elm-test)"
    let g:test#javascript#elm#executable = 'node_modules/.bin/elm-test'
    view tests/NormalTest.elm
    TestFile

    Expect g:test#last_command == 'node_modules/.bin/elm-test tests/NormalTest.elm'
  end

  it "runs tests against absolute path of npm executable (elm-test and elm-compiler)"
    let g:test#javascript#elm#executable = 'node_modules/.bin/elm-test --compiler node_modules/.bin/elm'
    view tests/NormalTest.elm
    TestFile

    Expect g:test#last_command == 'node_modules/.bin/elm-test --compiler node_modules/.bin/elm tests/NormalTest.elm'
  end
end
