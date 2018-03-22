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
    view +1 features/normal.feature
    TestNearest

    Expect g:test#last_command == 'cucumber features/normal.feature:1'
  end

  it "runs file tests"
    view features/normal.feature
    TestFile

    Expect g:test#last_command == 'cucumber features/normal.feature'
  end

  it "runs test suites"
    view features/normal.feature
    TestSuite

    Expect g:test#last_command == 'cucumber'
  end

end
