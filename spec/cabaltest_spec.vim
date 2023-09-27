source spec/support/helpers.vim

describe "CABAL"

  before
    let g:test#haskell#runner = 'cabaltest'
    cd spec/fixtures/cabal
  end

  after
    call Teardown()
    cd -
  end

  it "runs when filename matches *Spec.hs"
    view FixtureSpec.hs
    TestFile

    Expect g:test#last_command == "cabal test --test-option=--match=\"Fixture\""
  end

  it "runs nearest tests"
    view +9 FixtureSpec.hs
    TestNearest

    Expect g:test#last_command == "cabal test --test-option=--match=\"returns the first element of a list\""
  end

  it "runs all test in a suite"
    view FixtureSpec.hs
    TestSuite

    Expect g:test#last_command == 'cabal test'
  end

  it "allows overriding the test command"
    let g:test#haskell#cabaltest#test_command = 'test .'

    view FixtureSpec.hs
    TestSuite

    Expect g:test#last_command == 'cabal test .'
  end

end

