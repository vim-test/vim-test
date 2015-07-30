source spec/helpers.vim

describe "Behat"

  before
    cd spec/fixtures/behat
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +3 normal.feature
    TestNearest

    Expect g:test#last_command == 'behat normal.feature:2'
  end

  it "runs file tests"
    view normal.feature
    TestFile

    Expect g:test#last_command == 'behat normal.feature'
  end

  it "runs test suites"
    view normal.feature
    TestSuite

    Expect g:test#last_command == 'behat'
  end

end
