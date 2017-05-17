source spec/support/helpers.vim

describe "Nose2"

  before
    let g:test#python#runner = 'Nose2'
    cd spec/fixtures/nose
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +2 test_class.py
    TestNearest

    Expect g:test#last_command == 'nose2 test_class.TestNumbers.test_numbers'

    view +5 test_class.py
    TestNearest

    Expect g:test#last_command == 'nose2 test_class.TestSubclass'

    view +1 test_class.py
    TestNearest

    Expect g:test#last_command == 'nose2 test_class.TestNumbers'

    view +1 test_method.py
    TestNearest

    Expect g:test#last_command == 'nose2 test_method.test_numbers'
  end

  it "runs file test if nearest test couldn't be found"
    view +1 test_method.py
    normal O
    TestNearest

    Expect g:test#last_command == 'nose2 test_method'
  end

  it "runs file tests"
    view test_class.py
    TestFile

    Expect g:test#last_command == 'nose2 test_class'
  end

  it "runs test suites"
    view test_class.py
    TestSuite

    Expect g:test#last_command == 'nose2'
  end

end
