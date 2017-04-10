source spec/support/helpers.vim

describe "Crystal"

  before
    cd spec/fixtures/crystal
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +1 normal_spec.cr
    TestNearest

    Expect g:test#last_command == 'crystal spec normal_spec.cr:1'
  end

  it "runs file tests"
    view normal_spec.cr
    TestFile

    Expect g:test#last_command == 'crystal spec normal_spec.cr'
  end

  it "runs test suites"
    view normal_spec.cr
    TestSuite

    Expect g:test#last_command == 'crystal spec'
  end
end
