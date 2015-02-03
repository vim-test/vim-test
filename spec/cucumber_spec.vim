source spec/helpers.vim

describe "Cucumber"

  before
    cd spec/fixtures/cucumber
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +1 normal.feature
    TestNearest

    Expect LastCommand() == 'cucumber normal.feature:1'
  end

  it "runs file tests"
    view normal.feature
    TestFile

    Expect LastCommand() == 'cucumber normal.feature'
  end

  it "runs test suites"
    view normal.feature
    TestSuite

    Expect LastCommand() == 'cucumber'
  end

end
