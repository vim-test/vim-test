source spec/helpers.vim

describe "ExUnit"

  before
    cd spec/fixtures/exunit
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +1 normal_test.exs
    TestNearest

    Expect LastCommand() == 'mix test normal_test.exs:1'
  end

  it "runs file tests"
    view normal_test.exs
    TestFile

    Expect LastCommand() == 'mix test normal_test.exs'
  end

  it "runs test suites"
    view normal_test.exs
    TestSuite

    Expect LastCommand() == 'mix test'
  end

end
