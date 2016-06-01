source spec/support/helpers.vim

describe "Bats"

  before
    cd spec/fixtures/bats
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests instead of nearest tests"
    view normal.bats
    TestNearest

    Expect g:test#last_command == 'bats normal.bats'
  end

  it "runs file tests"
    view normal.bats
    TestFile

    Expect g:test#last_command == 'bats normal.bats'
  end

  it "runs test suites"
    view normal.bats
    TestSuite

    Expect g:test#last_command == 'bats test/'
  end

end
