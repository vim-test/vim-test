source spec/support/helpers.vim

describe "RichGo"
  before
    cd spec/fixtures/richgo
    let g:test#go#runner = 'richgo'
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +5 normal_test.go
    TestNearest
    Expect g:test#last_command == "richgo test -run 'TestNumbers$' ./."
  end

  it "runs nearest tests in subdirectory"
    view +5 mypackage/normal_test.go
    TestNearest
    Expect g:test#last_command == "richgo test -run 'TestNumbers$' ./mypackage"
  end

  it "runs file test if nearest test couldn't be found"
    view +1 normal_test.go
    TestNearest
    Expect g:test#last_command == 'richgo test'
  end

  it "runs file tests"
    view normal_test.go
    TestFile
    Expect g:test#last_command == 'richgo test'
  end

  it "runs file tests in subdirectory"
    view mypackage/normal_test.go
    TestFile
    Expect g:test#last_command == 'richgo test ./mypackage/...'
  end

  it "runs test suites"
    view normal_test.go
    TestSuite
    Expect g:test#last_command == 'richgo test ./...'
  end
end
