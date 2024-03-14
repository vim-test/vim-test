source spec/support/helpers.vim

describe "PyTest_xunit"
  " using xunit as a testing framework (unittest.*)

  before
    let g:test#python#runner = 'pytest'
    cd spec/fixtures/nose
  end

  after
    unlet g:test#python#runner
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +1 test_class.py
    TestNearest

    Expect g:test#last_command == 'python3 -m pytest test_class.py::TestNumbers'

    view +2 test_class.py
    TestNearest

    Expect g:test#last_command == 'python3 -m pytest test_class.py::TestNumbers::test_numbers'

    view +7 test_class.py
    TestNearest

    Expect g:test#last_command == 'python3 -m pytest test_class.py::TestSubclass::test_subclass'

    view +9 test_class.py
    TestNearest

    Expect g:test#last_command == 'python3 -m pytest test_class.py::Test_underscores_and_123'

    view +11 test_class.py
    TestNearest

    Expect g:test#last_command == 'python3 -m pytest test_class.py::Test_underscores_and_123::test_underscores'

    view +13 test_class.py
    TestNearest

    Expect g:test#last_command == 'python3 -m pytest test_class.py::UnittestClass'

    view +19 test_class.py
    TestNearest

    Expect g:test#last_command == 'python3 -m pytest test_class.py::SomeTest::test_foo'

    view +1 test_method.py
    TestNearest

    Expect g:test#last_command == 'python3 -m pytest test_method.py::test_numbers'
  end

  " it "runs nearest tests ignoring nested classes"
  "   view +6 test_method.py
  "   TestNearest
  "
  "   Expect g:test#last_command == 'python3 -m pytest test_method.py::test_foo'
  " end

  it "runs file test if nearest test couldn't be found"
    view +1 test_method.py
    normal O
    TestNearest

    Expect g:test#last_command == 'python3 -m pytest test_method.py'
  end

  it "runs class tests"
    view +5 test_class.py
    TestClass

    Expect g:test#last_command == 'python3 -m pytest test_class.py::TestSubclass'

    view +6 test_class.py
    TestClass

    Expect g:test#last_command == 'python3 -m pytest test_class.py::TestSubclass'
  end

  it "runs file tests"
    view test_class.py
    TestFile

    Expect g:test#last_command == 'python3 -m pytest test_class.py'
  end

  it "runs test suites"
    view test_class.py
    TestSuite

    Expect g:test#last_command == 'python3 -m pytest'
  end

end



describe "Pytest"
  " using pytest as a testing framework instead of xunit (unittest.*)
  before
    let g:test#python#runner = 'pytest'
    cd spec/fixtures/pytest
  end

  after
    unlet g:test#python#runner
    call Teardown()
    cd -
  end

  it ":TestNearest (class)"
    view +1 test_class.py
    TestNearest 
    Expect g:test#last_command == 'python3 -m pytest test_class.py::TestClass'
  end

  it ":TestNearest (nested-class)"
    view +2 test_class.py
    TestNearest 
    Expect g:test#last_command == 'python3 -m pytest test_class.py::TestClass::TestNestedClass'
  end

  it ":TestNearest (nested-class-method)"
    view +3 test_class.py
    TestNearest 
    Expect g:test#last_command == 'python3 -m pytest test_class.py::TestClass::TestNestedClass::test_nestedclass_method'
  end

  it ":TestNearest (method)"
    view +6 test_class.py
    TestNearest 
    Expect g:test#last_command == 'python3 -m pytest test_class.py::TestClass::test_method'
  end

  it ":TestNearest (function)"
    view +10 test_class.py
    TestNearest 
    Expect g:test#last_command == 'python3 -m pytest test_class.py::test_function'
  end

  it ":TestClass (function)"
    view +15 test_class.py
    TestClass 
    Expect g:test#last_command == 'python3 -m pytest test_class.py::TestClass2'
  end
end

describe "Pytest"
  before
    cd spec/fixtures/pytest
  end

  after
    call Teardown()
    cd -
  end

  it "TestFile with import pytest"
    view +1 test_expectation.py
    TestFile
    Expect g:test#last_command == 'python3 -m pytest test_expectation.py'
  end
end

describe "Pytest running Nose tests when pytest.ini present"
  before
    cd spec/fixtures/nose
    !touch pytest.ini
  end

  after
    !rm pytest.ini
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +1 test_class.py
    TestNearest

    Expect g:test#last_command == 'python3 -m pytest test_class.py::TestNumbers'
  end

  it "runs file tests"
    view test_class.py
    TestFile

    Expect g:test#last_command == 'python3 -m pytest test_class.py'
  end

  it "runs test suites"
    view test_class.py
    TestSuite

    Expect g:test#last_command == 'python3 -m pytest'
  end
end

describe "Pytest running Nose tests when pyproject.toml present with [tool.pytest.ini_options]"
  before
    cd spec/fixtures/nose
    !echo "[tool.pytest.ini_options]" >> pyproject.toml
  end

  after
    !rm pyproject.toml
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +1 test_class.py
    TestNearest

    Expect g:test#last_command == 'python3 -m pytest test_class.py::TestNumbers'
  end

  it "runs file tests"
    view test_class.py
    TestFile

    Expect g:test#last_command == 'python3 -m pytest test_class.py'
  end

  it "runs test suites"
    view test_class.py
    TestSuite

    Expect g:test#last_command == 'python3 -m pytest'
  end
end

describe "Pytest running Nose tests when tox.ini present with [pytest]"
  before
    cd spec/fixtures/nose
    !echo "[pytest]" >> tox.ini
  end

  after
    !rm tox.ini
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +1 test_class.py
    TestNearest

    Expect g:test#last_command == 'python3 -m pytest test_class.py::TestNumbers'
  end

  it "runs file tests"
    view test_class.py
    TestFile

    Expect g:test#last_command == 'python3 -m pytest test_class.py'
  end

  it "runs test suites"
    view test_class.py
    TestSuite

    Expect g:test#last_command == 'python3 -m pytest'
  end
end

describe "Pytest running Nose tests when setup.cfg present with [tool:pytest]"
  before
    cd spec/fixtures/nose
    !echo "[tool:pytest]" >> setup.cfg
  end

  after
    !rm setup.cfg
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +1 test_class.py
    TestNearest

    Expect g:test#last_command == 'python3 -m pytest test_class.py::TestNumbers'
  end

  it "runs file tests"
    view test_class.py
    TestFile

    Expect g:test#last_command == 'python3 -m pytest test_class.py'
  end

  it "runs test suites"
    view test_class.py
    TestSuite

    Expect g:test#last_command == 'python3 -m pytest'
  end
end
