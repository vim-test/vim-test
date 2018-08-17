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

    Expect g:test#last_command == 'sbt "testOnly *FixtureTestSuite"'
  end

  it "runs when filename matches *Suite.scala"
    view FixtureSuite.scala
    TestFile

    Expect g:test#last_command == 'sbt "testOnly *FixtureTestSuite"'
  end

  it "runs when filename matches Test*.scala"
    view TestFixture.scala
    TestFile

    Expect g:test#last_command == 'sbt "testOnly *FixtureTestSuite"'
  end

  it "runs when filename matches Suite*.scala"
    view SuiteFixture.scala
    TestFile

    Expect g:test#last_command == 'sbt "testOnly *FixtureTestSuite"'
  end

  it "runs when filename matches *test*.scala"
    view whatever_test_smth.scala
    TestFile

    Expect g:test#last_command == 'sbt "testOnly *FixtureTestSuite"'
  end

  it "runs when filename matches *suite*.scala"
    view whatever_suite_smth.scala
    TestFile

    Expect g:test#last_command == 'sbt "testOnly *FixtureTestSuite"'
  end

  it "runs nearest tests"
    view +32 FixtureTestSuite.scala
    TestNearest

    Expect g:test#last_command == 'sbt "testOnly *FixtureTestSuite \"Assert \'add\' works for Double and returns Double\""'
  end

  it "runs a suite"
    view FixtureTestSuite.scala
    TestSuite

    Expect g:test#last_command == 'sbt "testOnly *FixtureTestSuite"'
  end

end
