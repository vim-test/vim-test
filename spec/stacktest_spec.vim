source spec/support/helpers.vim

describe "STACK"

  before
    cd spec/fixtures/stack
  end

  after
    call Teardown()
    cd -
  end

  it "runs when filename matches *Spec.hs"
    view FixtureSpec.hs
    TestFile

    Expect g:test#last_command == "stack test --test-arguments '-m \"Fixture\"'"
  end

  it "runs nearest tests"
    view +9 FixtureSpec.hs
    TestNearest

    Expect g:test#last_command == "stack test --test-arguments '-m \"returns the first element of a list\"'"
  end

  it "runs all test in a suite"
    view FixtureSpec.hs
    TestSuite

    Expect g:test#last_command == 'stack "test"'
  end

end
