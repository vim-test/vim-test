source spec/support/helpers.vim

describe "STACK (single-package)"

  before
    cd spec/fixtures/stack/single-package
  end

  after
    call Teardown()
    cd -
  end


  it "TestSuite runs all tests"
    view test/Spec.hs
    TestSuite

    Expect g:test#last_command == "stack test"
  end

  it "TestFile runs all tests in main test module"
    view test/Spec.hs
    TestFile

    Expect g:test#last_command == "stack test"
  end

  it "TestNearest runs all tests in main test module"
    view test/Spec.hs
    TestNearest

    Expect g:test#last_command == "stack test"
  end

  it "TestFile detects fully qualified module name (qualified imports)"
    view test/Fix/FixtureSpec.hs
    TestFile

    Expect g:test#last_command == "stack test --test-arguments '-m \"Fix.Fixture\"'"
  end

  it "TestNearest runs nearest 'it' test (qualified imports)"
    view +9 test/Fix/FixtureSpec.hs
    TestNearest

    Expect g:test#last_command == "stack test --test-arguments '-m \"Fix.Fixture/Prelude.head/returns the first element of a list\"'"
  end

  it "TestNearest runs nearest 'prop' test (qualified imports)"
    view +11 test/Fix/FixtureSpec.hs
    TestNearest

    Expect g:test#last_command == "stack test --test-arguments '-m \"Fix.Fixture/Prelude.head/returns the first element of an *arbitrary* list\"'"
  end

  it "TestNearest detects nested describes (qualfied imports)"
    view +14 test/Fix/FixtureSpec.hs
    TestNearest

    Expect g:test#last_command == "stack test --test-arguments '-m \"Fix.Fixture/Prelude.head/Empyt list/throws an exception if used with an empty list\"'"
  end
  
end
