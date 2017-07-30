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

end
