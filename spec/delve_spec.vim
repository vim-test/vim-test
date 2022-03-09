source spec/support/helpers.vim

describe "Delve"

  before
    let g:test#go#runner = "delve"
    cd spec/fixtures/delve
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +5 normal_test.go
    TestNearest

    Expect g:test#last_command == 'dlv test ./. -- -test.run ''TestNumbers$'''

    view +9 normal_test.go
    TestNearest

    Expect g:test#last_command == 'dlv test ./. -- -test.run ''Testテスト$'''

    view +13 normal_test.go
    TestNearest

    Expect g:test#last_command == 'dlv test ./. -- -test.run ''ExampleSomething$'''

    view +17 ginkgo_test.go
    TestNearest

    Expect g:test#last_command == "dlv test ./. -- -ginkgo.focus='should paginate the result'"
  end

  it "runs nearest tests in subdirectory"
    view +5 mypackage/normal_test.go
    TestNearest

    Expect g:test#last_command == 'dlv test ./mypackage -- -test.run ''TestNumbers$'''

    view +9 mypackage/normal_test.go
    TestNearest

    Expect g:test#last_command == 'dlv test ./mypackage -- -test.run ''Testテスト$'''

    view +13 mypackage/normal_test.go
    TestNearest

    Expect g:test#last_command == 'dlv test ./mypackage -- -test.run ''ExampleSomething$'''
  end

  it "runs file test if nearest test couldn't be found"
    view +1 normal_test.go
    TestNearest

    Expect g:test#last_command == 'dlv test'
  end

  it "runs file tests"
    view normal_test.go
    TestFile

    Expect g:test#last_command == 'dlv test'
  end

  it "runs tests in subdirectory"
    view mypackage/normal_test.go
    TestFile

    Expect g:test#last_command == 'dlv test ./mypackage/...'
  end

  it "runs test suites"
    view normal_test.go
    TestSuite

    Expect g:test#last_command == 'dlv test ./...'
  end

  describe "when options are defined"
    before
      let g:test#go#delve#options = '-test.v'
    end
    after
      unlet g:test#go#delve#options
    end
    it "appends options to the end in a suite test"
      view normal_test.go
      TestSuite

      Expect g:test#last_command == 'dlv test ./... -- -test.v'
    end
    it "appends options to the end in a nearest test"
      view +5 normal_test.go
      TestNearest

      Expect g:test#last_command == 'dlv test ./. -- -test.run ''TestNumbers$'' -test.v'
    end
  end
end
