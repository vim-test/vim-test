source spec/support/helpers.vim

describe "STACK (multi-package)"

  before
    cd spec/fixtures/stack/multi-package
  end

  after
    call Teardown()
    cd -
  end


  it "TestSuite detects correct subpackage (1)"
    view subpackage1/test/Spec.hs
    TestSuite

    Expect g:test#last_command == "stack test subpackage1"
  end

  it "TestSuite detects correct subpackage (2)"
    view subpackage2/test/Spec.hs
    TestSuite

    Expect g:test#last_command == "stack test subpackage2"
  end

  it "TestSuite detects correct subpackage in subdirectory"
    view common/subpackage3/test/Spec.hs
    TestSuite

    Expect g:test#last_command == "stack test subpackage3"
  end

  it "TestFile detects fully qualified module name and correct subpackage (1)"
    view subpackage1/test/Fix1/FixtureSpec.hs
    TestFile

    Expect g:test#last_command == "stack test subpackage1 --test-arguments '-m \"Fix1.Fixture\"'"
  end

  it "TestFile detects fully qualified module name and correct subpackage (2)"
    view subpackage2/test/Fix2/FixtureSpec.hs
    TestFile

    Expect g:test#last_command == "stack test subpackage2 --test-arguments '-m \"Fix2.Fixture\"'"
  end

  it "TestFile detects fully qualified module name and correct subpackage (in subdirectory)"
    view common/subpackage3/test/Fix3/FixtureSpec.hs
    TestFile

    Expect g:test#last_command == "stack test subpackage3 --test-arguments '-m \"Fix3.Fixture\"'"
  end

  it "TestNearest runs nearest 'it' test and detects correct subpackage"
    view +11 subpackage1/test/Fix1/FixtureSpec.hs
    TestNearest

    Expect g:test#last_command == "stack test subpackage1 --test-arguments '-m \"returns the first element of a list\"'"
  end

  it "TestNearest runs nearest 'prop' test and detects correct subpackage"
    view +13 subpackage1/test/Fix1/FixtureSpec.hs
    TestNearest

    Expect g:test#last_command == "stack test subpackage1 --test-arguments '-m \"returns the first element of an *arbitrary* list\"'"
  end

  " TODO
  " it "TestNearest detects nested describes"
  "   view +17 subpackage1/test/Fix1/FixtureSpec.hs
  "   TestNearest
  "
  "   Expect g:test#last_command == "stack test subpackage1 --test-arguments '-m \"Fix1.Fixture/Prelude.head/Empyt list/throws an exception if used with an empty list\"'"
  " end
  
end
