source spec/helpers.vim

describe "GoTest"

  before
    cd spec/fixtures/gotest
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +5 normal_test.go
    TestNearest

    Expect LastCommand() == 'go test normal_test.go -run ''TestNumbers'''
  end

  it "runs file test if nearest test couldn't be found"
    view +1 normal_test.go
    TestNearest

    Expect LastCommand() == 'go test normal_test.go'
  end

  it "runs file tests"
    view normal_test.go
    TestFile

    Expect LastCommand() == 'go test normal_test.go'
  end

  it "runs test suites"
    view normal_test.go
    TestSuite

    Expect LastCommand() == 'go test'
  end

end
