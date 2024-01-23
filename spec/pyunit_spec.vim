source spec/support/helpers.vim

describe "PyUnitTest"

  before
    cd spec/fixtures/pyunit
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +3 test_class.py
    TestNearest

    Expect g:test#last_command == 'python3 -m unittest test_class.TestStringMethods'

    view +5 test_class.py
    TestNearest

    Expect g:test#last_command == 'python3 -m unittest test_class.TestStringMethods.test_upper'

    view +8 test_class.py
    TestNearest

    Expect g:test#last_command == 'python3 -m unittest test_class.TestStringMethods.test_isupper'

    view +12 test_class.py
    TestNearest

    Expect g:test#last_command == 'python3 -m unittest test_class.TestStringMethods.test_split'
  end

  it "runs file test if nearest test couldn't be found"
    view +3 normal_test.py
    normal O
    TestNearest

    Expect g:test#last_command == 'python3 -m unittest normal_test'
  end

  it "runs file tests"
    view test_class.py
    TestFile

    Expect g:test#last_command == 'python3 -m unittest test_class'

    view normal_test.py
    TestFile

    Expect g:test#last_command == 'python3 -m unittest normal_test'

    view test_import_testcase.py
    TestFile

    Expect g:test#last_command == 'python3 -m unittest test_import_testcase'
  end

  it "runs test suites"
    view test_class.py
    TestSuite

    Expect g:test#last_command == 'python3 -m unittest'
  end

end
