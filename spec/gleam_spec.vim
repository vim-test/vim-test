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

  context "when project root is in a subdirectory"
    before
      cd ..
    end

    it "runs file tests from directory with root marker"
      let cwd_initial = getcwd()
      view gleam/normal.gleam
      TestFile

      Expect g:test#last_command == "gleam test normal.gleam"
      Expect getcwd() == cwd_initial
    end
  end
end
