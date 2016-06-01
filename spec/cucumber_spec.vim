source spec/support/helpers.vim

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

    Expect g:test#last_command == 'cucumber normal.feature:1'
  end

  it "runs file tests"
    view normal.feature
    TestFile

    Expect g:test#last_command == 'cucumber normal.feature'
  end

  it "runs test suites"
    view normal.feature
    TestSuite

    Expect g:test#last_command == 'cucumber'
  end

end
