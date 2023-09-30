source spec/support/helpers.vim

describe "CABAL (single-package)"

  before
    let g:test#haskell#runner = 'cabaltest'
    cd spec/fixtures/cabal/single-package
  end

  after
    call Teardown()
    cd -
  end


  it "TestSuite runs all tests"
    view test/Spec.hs
    TestSuite

    Expect g:test#last_command == "cabal test"
  end

  it "TestFile runs all tests in main test module"
    view test/Spec.hs
    TestFile

    Expect g:test#last_command == "cabal test"
  end

  it "TestNearest runs all tests in main test module"
    view test/Spec.hs
    TestNearest

    Expect g:test#last_command == "cabal test"
  end

  it "TestFile detects fully qualified module name (qualified imports)"
    view test/Fix/FixtureSpec.hs
    TestFile

    Expect g:test#last_command == "cabal test --test-option=--match=\"Fix.Fixture\""
  end

  it "TestNearest runs nearest 'it' (qualified imports)"
    view +10 test/Fix/FixtureSpec.hs
    TestNearest

    Expect g:test#last_command == "cabal test --test-option=--match=\"returns the first element of a list\""
  end

  it "TestNearest runs nearest 'prop' test (qualified imports)"
    view +12 test/Fix/FixtureSpec.hs
    TestNearest

    Expect g:test#last_command == "cabal test --test-option=--match=\"returns the first element of an *arbitrary* list\""
  end

  " TODO ?
  " it "TestNearest correctly traverses the describe tree from node to root (qualfied imports)"
  "   view +19 test/Fix/FixtureSpec.hs
  "   TestNearest
  "
  "   Expect g:test#last_command == "cabal test --test-option=--match=\"/Prelude.head/Empyt list/throws an exception if used with an empty list\""
  " end
  
  it "TestFile detects fully qualified module name (unqualified imports)"
    view test/Fix/Fixture2Spec.hs
    TestFile

    Expect g:test#last_command == "cabal test --test-option=--match=\"Fix.Fixture2\""
  end

  it "TestNearest runs nearest 'it' test (unqualified imports)"
    view +13 test/Fix/Fixture2Spec.hs
    TestNearest

    Expect g:test#last_command == "cabal test --test-option=--match=\"returns the first element of a list\""
  end

  it "TestNearest runs nearest 'prop' test (unqualified imports)"
    view +15 test/Fix/Fixture2Spec.hs
    TestNearest

    Expect g:test#last_command == "cabal test --test-option=--match=\"returns the first element of an *arbitrary* list\""
  end

  " TODO ?
  " it "TestNearest correctly traverses the describe tree from node to root (unqualfied imports)"
  "   view +19 test/Fix/Fixture2Spec.hs
  "   TestNearest
  "
  "   Expect g:test#last_command == "cabal test --test-option=--match=\"/Prelude.head/Empyt list/throws an exception if used with an empty list\""
  " end
  "
  it "TestFile detects fully qualified module name (with language pragmas)"
    view test/Fix/Fixture3Spec.hs
    TestFile

    Expect g:test#last_command == "cabal test --test-option=--match=\"Fix.Fixture3\""
  end

  
end

