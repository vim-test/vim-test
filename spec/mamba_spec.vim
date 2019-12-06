source spec/support/helpers.vim

describe "Mamba"
  before
    let g:test#python#runner = 'mamba'
    cd spec/fixtures/mamba
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +1 normal_spec.py
    TestNearest

    Expect g:test#last_command == 'mamba normal_spec.py'
  end

  it "runs file tests"
    view normal_spec.py
    TestFile

    Expect g:test#last_command == 'mamba normal_spec.py'
  end

  it "runs test suites"
    view normal_spec.py
    TestSuite

    Expect g:test#last_command == 'mamba'
  end
end
