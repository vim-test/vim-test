source spec/support/helpers.vim

describe "Gleam"

  before
    cd spec/fixtures/gleam
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest test"
    view +1 normal.gleam
    TestNearest

    Expect g:test#last_command == "gleam test normal.gleam"
  end

  it "runs file tests"
    view normal.gleam
    TestFile

    Expect g:test#last_command == "gleam test normal.gleam"
  end

  it "runs test suite"
    view normal.gleam
    TestSuite

    Expect g:test#last_command == "gleam test"
  end
end
