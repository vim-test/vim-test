source spec/support/helpers.vim

describe "Go Runner"
  before
    cd spec/fixtures
  end
  
  after
    cd -
  end

  describe "when test#go#runner is not set"
    after
      call Teardown()
    end
    it "should use ginkgo if 'github.com/onsi/ginkgo' is found"
      view ginkgo/normal_test.go
      TestFile
      Expect g:test#last_command =~# '\v^ginkgo'
    end
    it "should use gotest otherwise"
      view gotest/normal_test.go
      TestFile
      Expect g:test#last_command =~# '\v^go test'
    end
  end

  describe "when test#go#runner is set"
    it "should respect test#go#runner"
      for runner in ["ginkgo", "gotest"]
        let g:test#go#runner = runner
        Expect test#determine_runner("ginkgo/normal_test.go") == 'go#'.runner
        Expect test#determine_runner("gotest/normal_test.go") == 'go#'.runner
      endfor
    end
  end


