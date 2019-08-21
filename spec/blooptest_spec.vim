source spec/support/helpers.vim

describe "Bloop"

  before
    cd spec/fixtures/sbt
    let g:test#scala#runner = 'blooptest'
    let g:test#scala#blooptest#project_name = 'bloop_project'
  end

  after
    call Teardown()
    cd -
  end

  it "runs when filename matches *Test.scala"
    view FixtureTest.scala
    TestFile

    Expect g:test#last_command == 'bloop test bloop_project -o "*FixtureTest"'
  end

  it "runs when filename matches *Suite.scala"
    view FixtureSuite.scala
    TestFile

    Expect g:test#last_command == 'bloop test bloop_project -o "*FixtureSuite"'
  end

  it "runs when filename matches Test*.scala"
    view TestFixture.scala
    TestFile

    Expect g:test#last_command == 'bloop test bloop_project -o "*TestFixture"'
  end

  it "runs when filename matches Suite*.scala"
    view SuiteFixture.scala
    TestFile

    Expect g:test#last_command == 'bloop test bloop_project -o "*SuiteFixture"'
  end

  it "runs when filename matches *test*.scala"
    view whatever_test_smth.scala
    TestFile

    Expect g:test#last_command == 'bloop test bloop_project -o "*whatever_test_smth"'
  end

  it "runs when filename matches *suite*.scala"
    view whatever_suite_smth.scala
    TestFile

    Expect g:test#last_command == 'bloop test bloop_project -o "*whatever_suite_smth"'
  end

  it "runs nearest tests"
    view +32 FixtureTestSuite.scala
    TestNearest

    Expect g:test#last_command == 'bloop test bloop_project -o "*FixtureTestSuite" -- -z "Assert ''add'' works for Double and returns Double"'
  end

  it "runs a suite"
    view FixtureTestSuite.scala
    TestSuite

    Expect g:test#last_command == 'bloop test bloop_project'
  end

end
