source spec/support/helpers.vim

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

    Expect g:test#last_command == 'go test -run ''TestNumbers$'' ./.'

    view +9 normal_test.go
    TestNearest

    Expect g:test#last_command == 'go test -run ''Testテスト$'' ./.'

    view +13 normal_test.go
    TestNearest

    Expect g:test#last_command == 'go test -run ''ExampleSomething$'' ./.'
  end

  it "runs nearest tests in subdirectory"
    view +5 mypackage/normal_test.go
    TestNearest

    Expect g:test#last_command == 'go test -run ''TestNumbers$'' ./mypackage'

    view +9 mypackage/normal_test.go
    TestNearest

    Expect g:test#last_command == 'go test -run ''Testテスト$'' ./mypackage'

    view +13 mypackage/normal_test.go
    TestNearest

    Expect g:test#last_command == 'go test -run ''ExampleSomething$'' ./mypackage'
  end

  it "runs file test if nearest test couldn't be found"
    view +1 normal_test.go
    TestNearest

    Expect g:test#last_command == 'go test'
  end

  it "runs file tests"
    view normal_test.go
    TestFile

    Expect g:test#last_command == 'go test'
  end

  it "runs tests in subdirectory"
    view mypackage/normal_test.go
    TestFile

    Expect g:test#last_command == 'go test ./mypackage/...'
  end

  it "runs test suites"
    view normal_test.go
    TestSuite

    Expect g:test#last_command == 'go test ./...'
  end

end
