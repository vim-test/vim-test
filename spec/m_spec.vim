source spec/support/helpers.vim

describe "M"

  before
    cd spec/fixtures/minitest
    let g:test#ruby#minitest#executable = 'm'
  end

  after
    call Teardown()
    cd -
    unlet g:test#ruby#minitest#executable
  end

  it "runs nearest tests"
    view +1 normal_test.rb
    TestNearest

    Expect g:test#last_command == 'm normal_test.rb:1'
  end

  it "runs file tests"
    view normal_test.rb
    TestFile

    Expect g:test#last_command == 'm normal_test.rb'
  end

  it "runs test suites"
    view normal_test.rb
    TestSuite

    Expect g:test#last_command == 'm'
  end

end
