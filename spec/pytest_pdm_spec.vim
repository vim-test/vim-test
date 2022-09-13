source spec/support/helpers.vim

describe "PyTest PDM§"
  before
    let g:test#python#runner = 'pytest'
    cd spec/fixtures/nose
    !touch pdm.lock
  end

  after
    call Teardown()
    !rm pdm.lock
    cd -
  end

  it "runs nearest tests"
    view +1 test_class.py
    TestNearest

    Expect g:test#last_command == 'pdm run pytest test_class.py::TestNumbers'
  end

  it "runs file test if nearest test couldn't be found"
    view +1 test_method.py
    normal O
    TestNearest

    Expect g:test#last_command == 'pdm run pytest test_method.py'
  end

  it "runs file tests"
    view test_class.py
    TestFile

    Expect g:test#last_command == 'pdm run pytest test_class.py'
  end

  it "runs test suites"
    view test_class.py
    TestSuite

    Expect g:test#last_command == 'pdm run pytest'
  end
end
