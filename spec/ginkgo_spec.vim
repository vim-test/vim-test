source spec/support/helpers.vim

describe "Ginkgo"

  before
    cd spec/fixtures/ginkgo
  end

  after
    call Teardown()
    cd -
  end

  describe "TestNearest"
    it "runs nearest test identified by 'It'"
      view +17 normal_test.go
      TestNearest

      Expect g:test#last_command == "ginkgo --focus='should paginate the result' ./."
    end

    it "runs nearest tests identified by 'Context'"
      view +11 normal_test.go
      TestNearest

      Expect g:test#last_command == "ginkgo --focus='when the request is authenticated' ./."
    end

    it "runs nearest tests identified by 'Describe'"
      view +9 normal_test.go
      TestNearest

      Expect g:test#last_command == "ginkgo --focus='posts API' ./."
    end

  end

  it "runs nearest tests in subdirectory"
    view +17 mypackage/normal_test.go
    TestNearest

    Expect g:test#last_command == "ginkgo --focus='should paginate the result' ./mypackage"
  end

  it "runs file test if nearest test couldn't be found"
    view +1 mypackage/normal_test.go
    TestNearest
    Expect g:test#last_command == "ginkgo --regexScansFilePath=true --focus=mypackage/normal_test.go"
  end

  it "runs file tests"
    view normal_test.go
    TestFile

    Expect g:test#last_command == "ginkgo --regexScansFilePath=true --focus=normal_test.go"
  end

  it "runs tests in subdirectory"
    view mypackage/normal_test.go
    TestFile

    Expect g:test#last_command == "ginkgo --regexScansFilePath=true --focus=mypackage/normal_test.go"
  end

  it "runs test suites"
    view normal_test.go
    TestSuite

    Expect g:test#last_command == "ginkgo ./..."
  end

  describe "when test#go#runner is set"
    " make sure test#go#test_file doesn't have side-effect on cursor position
    it "runs nearest test"
      let g:test#go#runner = 'ginkgo'
      view +17 normal_test.go
      TestNearest

      Expect g:test#last_command == "ginkgo --focus='should paginate the result' ./."
    end
  end

end
