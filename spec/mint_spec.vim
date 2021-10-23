source spec/support/helpers.vim

describe "Mint"

  before
    cd spec/fixtures/mint
  end

  after
    call Teardown()
    cd -
  end

  it "does not run nearest tests"
    view +1 Main.mint
    TestNearest

    Expect g:test#last_command == 'mint test'
  end

  it "runs file tests"
    view Main.mint
    TestFile

    Expect g:test#last_command == 'mint test Main.mint'
  end

  it "runs test suites"
    view Main.mint
    TestSuite

    Expect g:test#last_command == 'mint test'
  end
end
