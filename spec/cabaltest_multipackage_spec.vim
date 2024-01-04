source spec/support/helpers.vim

describe "CABAL (multi-package)"

  before
    let g:test#haskell#runner = 'cabaltest'
    cd spec/fixtures/cabal/multi-package
  end

  after
    call Teardown()
    cd -
  end


  it "TestSuite detects correct subpackage (1)"
    view subpackage1/test/Spec.hs
    TestSuite

    Expect g:test#last_command == "cabal test subpackage1"
  end

  it "TestSuite detects correct subpackage (2)"
    view subpackage2/test/Spec.hs
    TestSuite

    Expect g:test#last_command == "cabal test subpackage2"
  end

  it "TestSuite detects correct subpackage in subdirectory"
    view common/subpackage3/test/Spec.hs
    TestSuite

    Expect g:test#last_command == "cabal test subpackage3"
  end

  it "TestFile detects fully qualified module name and correct subpackage (1)"
    view subpackage1/test/Fix1/FixtureSpec.hs
    TestFile

    Expect g:test#last_command == "cabal test subpackage1 --test-option=--match=\"Fix1.Fixture\""
  end

  it "TestFile detects fully qualified module name and correct subpackage (2)"
    view subpackage2/test/Fix2/FixtureSpec.hs
    TestFile

    Expect g:test#last_command == "cabal test subpackage2 --test-option=--match=\"Fix2.Fixture\""
  end

  it "TestFile detects fully qualified module name and correct subpackage (in subdirectory)"
    view common/subpackage3/test/Fix3/FixtureSpec.hs
    TestFile

    Expect g:test#last_command == "cabal test subpackage3 --test-option=--match=\"Fix3.Fixture\""
  end

  it "TestNearest runs nearest 'it' test and detects correct subpackage"
    view +11 subpackage1/test/Fix1/FixtureSpec.hs
    TestNearest

    Expect g:test#last_command == "cabal test subpackage1 --test-option=--match=\"returns the first element of a list\""
  end

  it "TestNearest runs nearest 'prop' test and detects correct subpackage"
    view +13 subpackage1/test/Fix1/FixtureSpec.hs
    TestNearest

    Expect g:test#last_command == "cabal test subpackage1 --test-option=--match=\"returns the first element of an *arbitrary* list\""
  end

  " TODO
  " it "TestNearest detects nested describes"
  "   view +17 subpackage1/test/Fix1/FixtureSpec.hs
  "   TestNearest
  "
  "   Expect g:test#last_command == "cabal test subpackage1 --test-option=--match=\"Fix1.Fixture/Prelude.head/Empyt list/throws an exception if used with an empty list\"'"
  " end
  
end
