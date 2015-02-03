source spec/helpers.vim

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

    Expect LastCommand() == 'bats normal.bats'
  end

  it "runs file tests"
    view normal.bats
    TestFile

    Expect LastCommand() == 'bats normal.bats'
  end

  it "runs test suites"
    view normal.bats
    TestSuite

    Expect LastCommand() == 'bats test/'
  end

end
