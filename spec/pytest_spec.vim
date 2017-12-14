source spec/support/helpers.vim

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
    view +1 test_class.py
    TestNearest

    Expect g:test#last_command == 'pytest test_class.py::TestNumbers'

    view +2 test_class.py
    TestNearest

    Expect g:test#last_command == 'pytest test_class.py::TestNumbers::test_numbers'

    view +7 test_class.py
    TestNearest

    Expect g:test#last_command == 'pytest test_class.py::TestSubclass::test_subclass'

    view +9 test_class.py
    TestNearest

    Expect g:test#last_command == 'pytest test_class.py::Test_underscores_and_123'

    view +11 test_class.py
    TestNearest

    Expect g:test#last_command == 'pytest test_class.py::Test_underscores_and_123::test_underscores'

    view +13 test_class.py
    TestNearest

    Expect g:test#last_command == 'pytest test_class.py::UnittestClass'

    view +19 test_class.py
    TestNearest

    Expect g:test#last_command == 'pytest test_class.py::SomeTest::test_foo'

    view +1 test_method.py
    TestNearest

    Expect g:test#last_command == 'pytest test_method.py::test_numbers'
  end

  " it "runs nearest tests ignoring nested classes"
  "   view +6 test_method.py
  "   TestNearest
  "
  "   Expect g:test#last_command == 'pytest test_method.py::test_foo'
  " end

  it "runs file test if nearest test couldn't be found"
    view +1 test_method.py
    normal O
    TestNearest

    Expect g:test#last_command == 'pytest test_method.py'
  end

  it "runs file tests"
    view test_class.py
    TestFile

    Expect g:test#last_command == 'pytest test_class.py'
  end

  it "runs test suites"
    view test_class.py
    TestSuite

    Expect g:test#last_command == 'pytest'
  end

end
