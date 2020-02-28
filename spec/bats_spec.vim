source spec/support/helpers.vim

describe "Bats"

  before
    cd spec/fixtures/bats
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest test"
    view +6 normal.bats
    TestNearest

    Expect g:test#last_command == 'bats normal.bats -f ''^numbers 2$'''

    view +1 normal.bats
    TestNearest

    Expect g:test#last_command == 'bats normal.bats -f ''^numbers$'''

    view +10 normal.bats
    TestNearest

    Expect g:test#last_command == 'bats normal.bats -f ''^single quotes$'''

    view +14 normal.bats
    TestNearest

    Expect g:test#last_command == 'bats normal.bats -f ''^indented$'''
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
