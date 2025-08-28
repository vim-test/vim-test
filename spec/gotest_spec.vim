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

    view +8 normal_test.go
    TestNearest

    Expect g:test#last_command == 'go test -run ''TestNumbers/adding_two_numbers$'' ./.'

    view +12 normal_test.go
    TestNearest

    let test_name = shellescape('\[\]\.\*\+\?\|\$\^\(\)')[1:-2]
    Expect g:test#last_command == 'go test -run ''TestNumbers/'. test_name .'$'' ./.'

    view +17 normal_test.go
    TestNearest

    Expect g:test#last_command == 'go test -run ''TestNumbers/this_is/nested$'' ./.'

    view +23 normal_test.go
    TestNearest

    Expect g:test#last_command == 'go test -run ''Testテスト$'' ./.'

    view +27 normal_test.go
    TestNearest

    Expect g:test#last_command == 'go test -run ''ExampleSomething$'' ./.'

    view +36 normal_test.go
    TestNearest

    Expect g:test#last_command == 'go test -run ''TestSomethingInASuite$'' ./.'
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

   view +22 mypackage/normal_test.go
    TestNearest

    Expect g:test#last_command == 'go test -run ''TestSomething$'' ./mypackage'
  end

  it "runs nearest testify case"
    view +18 testify_test.go
    TestNearest

    Expect g:test#last_command == 'go test ./. -run ''TestExampleTestSuite$'' -testify.m ''TestList'''

    view +18 testify_test.go
    TestNearest

    Expect g:test#last_command == 'go test ./. -run ''TestExampleTestSuite$'' -testify.m ''TestList'''

    view +23 testify_test.go
    TestNearest

    Expect g:test#last_command == 'go test ./. -run ''TestAnotherTestSuite$'' -testify.m ''TestAnother'''

    view +30 testify_test.go
    TestNearest

    Expect g:test#last_command == 'go test -run ''TestOriginalTestcase$'' ./.'
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

  it "runs tests in a file with build tags"
    view +14 build_tags_test.go
    TestNearest

    Expect g:test#last_command == 'go test -tags=foo,hello,world,!bar,red,black -run ''TestNumbers$'' ./.'

    TestFile

    Expect g:test#last_command == 'go test -tags=foo,hello,world,!bar,red,black'
  end

  it "runs tests in a file with only Go 1.17 build tags"
    view +10 build_tags_117_test.go
    TestNearest

    Expect g:test#last_command == 'go test -tags=foo,hello,world,!bar,red,black -run ''TestNumbers$'' ./.'

    TestFile

    Expect g:test#last_command == 'go test -tags=foo,hello,world,!bar,red,black'
  end

  it "runs test suite without tags"
    view +14 build_tags_test.go
    TestSuite

    Expect g:test#last_command == 'go test ./...'
  end

  it "runs test with args"
    view +5 normal_test.go
    let g:test#go#gotest#args = "a=b"
    TestNearest

    Expect g:test#last_command == 'go test -run ''TestNumbers$'' ./. -args a=b'
  end

  it "runs test suite with args"
    view +14 build_tags_test.go
    let g:test#go#gotest#args = "a=b"
    TestSuite

    Expect g:test#last_command == 'go test ./... -args a=b'
  end
end
