source spec/support/helpers.vim

describe "SBT"

  before
    cd spec/fixtures/sbt
  end

  after
    call Teardown()
    cd -
  end

  it "runs when filename matches *Test.scala"
    view FixtureTest.scala
    TestFile

    Expect g:test#last_command == 'sbt "testOnly *FixtureTest"'
  end

  it "runs when filename matches *Spec.scala"
    view FixtureSpec.scala
    TestFile

    Expect g:test#last_command == 'sbt "testOnly *FixtureSpec"'
  end

  it "runs when filename matches *Suite.scala"
    view FixtureSuite.scala
    TestFile

    Expect g:test#last_command == 'sbt "testOnly *FixtureSuite"'
  end

  it "runs when filename matches Test*.scala"
    view TestFixture.scala
    TestFile

    Expect g:test#last_command == 'sbt "testOnly *TestFixture"'
  end

  it "runs when filename matches Suite*.scala"
    view SuiteFixture.scala
    TestFile

    Expect g:test#last_command == 'sbt "testOnly *SuiteFixture"'
  end

  it "runs when filename matches *test*.scala"
    view whatever_test_smth.scala
    TestFile

    Expect g:test#last_command == 'sbt "testOnly *whatever_test_smth"'
  end

  it "runs when filename matches *suite*.scala"
    view whatever_suite_smth.scala
    TestFile

    Expect g:test#last_command == 'sbt "testOnly *whatever_suite_smth"'
  end

  it "runs nearest tests for FunSuite style"
    view +32 FixtureTestSuite.scala
    TestNearest

    Expect g:test#last_command == 'sbt "testOnly *FixtureTestSuite -- -z \"Assert '."\\'".'add'."\\'".' works for Double and returns Double\""'
  end

  it "runs nearest tests for FlatSpec style"
    view +14 FixtureSpec.scala
    TestNearest

    Expect g:test#last_command == 'sbt "testOnly *FixtureSpec -- -z \"throw NoSuchElementException if an empty stack is popped\""'
  end

  it "runs nearest tests for first test in FlatSpec style"
    view +6 FixtureSpec.scala
    TestNearest

    Expect g:test#last_command == 'sbt "testOnly *FixtureSpec -- -z \"A Stack should pop values in last-in-first-out order\""'
  end

  it "runs nearest tests for first test in WordSpec style"
    view +7 WordSpec.scala
    TestNearest

    Expect g:test#last_command == 'sbt "testOnly *WordSpec -- -z \"have size 0\""'
  end

  it "runs a suite"
    view FixtureTestSuite.scala
    TestSuite

    Expect g:test#last_command == 'sbt "test"'
  end

end
