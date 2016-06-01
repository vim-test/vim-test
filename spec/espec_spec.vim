source spec/support/helpers.vim

describe "ESpec"

  before
    cd spec/fixtures/espec
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +3 normal_spec.exs
    TestNearest

    Expect g:test#last_command == 'mix espec normal_spec.exs:3'
  end

  it "runs file tests"
    view normal_spec.exs
    TestFile

    Expect g:test#last_command == 'mix espec normal_spec.exs'
  end

  it "runs test suites"
    view normal_spec.exs
    TestSuite

    Expect g:test#last_command == 'mix espec'
  end

end
