source spec/support/helpers.vim

describe "Cargo"

  before
    cd spec/fixtures/cargo
  end

  after
    call Teardown()
    cd -
  end

  it "runs all for nearest tests"
    view normal_test.rs
    TestNearest

    Expect g:test#last_command == 'cargo test'
  end

  it "runs all for file tests"
    view normal_test.rs
    TestFile

    Expect g:test#last_command == 'cargo test'
  end

  it "runs test suites"
    view normal_test.rs
    TestSuite

    Expect g:test#last_command == 'cargo test'
  end

end

