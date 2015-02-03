source spec/helpers.vim

describe "PyTest"

  before
    let g:test#python#runner = 'pytest'
    cd spec/fixtures/nose
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +2 test_class.py
    TestNearest

    Expect g:test#last_command == 'py.test test_class.py -k test_numbers'

    view +1 test_class.py
    TestNearest

    Expect g:test#last_command == 'py.test test_class.py'

    view +1 test_method.py
    TestNearest

    Expect g:test#last_command == 'py.test test_method.py -k test_numbers'
  end

  it "runs file test if nearest test couldn't be found"
    view +1 test_method.py
    normal O
    TestNearest

    Expect g:test#last_command == 'py.test test_method.py'
  end

  it "runs file tests"
    view test_class.py
    TestFile

    Expect g:test#last_command == 'py.test test_class.py'
  end

  it "runs test suites"
    view test_class.py
    TestSuite

    Expect g:test#last_command == 'py.test'
  end

end
