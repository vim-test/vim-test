source spec/support/helpers.vim

describe "Rails"

  before
    cd spec/fixtures/rails
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +1 normal_test.rb
    TestNearest

    Expect g:test#last_command == 'rails test normal_test.rb:1'
  end

  it "runs file tests"
    view normal_test.rb
    TestFile

    Expect g:test#last_command == 'rails test normal_test.rb'
  end

  it "runs test suites"
    view normal_test.rb
    TestSuite

    Expect g:test#last_command == 'rails test'
  end

  context "when project root is in a subdirectory"
    before
      cd ..
    end

    it "runs file tests from directory with root marker"
      let cwd_initial = getcwd()
      view rails/normal_test.rb
      TestFile

      Expect g:test#last_command == 'rails test normal_test.rb'
      Expect getcwd() == cwd_initial
    end
  end
end
