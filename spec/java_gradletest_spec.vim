source spec/support/helpers.vim

describe "Gradle plain"
  before
    let g:test#java#runner = 'gradletest'
    cd spec/fixtures/gradle/java/gradle_plain
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests (filename matches Test*.java)"
    view TestMath.java
    TestFile

    Expect g:test#last_command == 'gradle test --tests TestMath'
  end

  it "runs file tests (filename matches *Test.java)"
    view MathTest.java
    TestFile

    Expect g:test#last_command == 'gradle test --tests MathTest'
  end

  it "runs file tests (filename matches *Tests.java)"
    view MathTests.java
    TestFile

    Expect g:test#last_command == 'gradle test --tests MathTests'
  end

  it "runs file tests (filename matches *TestCase.java)"
    view MathTestCase.java
    TestFile

    Expect g:test#last_command == 'gradle test --tests MathTestCase'
  end

  it "runs file tests with user provided options"
    view MathTest.java
    TestFile -b build.gradle

    Expect g:test#last_command == 'gradle test -b build.gradle --tests MathTest'
  end

  it "runs nearest tests"
    view +37 MathTest.java
    TestNearest

    Expect g:test#last_command == "gradle test --tests MathTest.testFailedAdd"
  end

  it "runs a suite"
    view MathTest.java
    TestSuite

    Expect g:test#last_command == 'gradle test'
  end

  it "runs a test suite with user provided options"
    view MathTest.java
    TestSuite --info -b build.gradle -DcustomProperty=5

    Expect g:test#last_command == 'gradle test --info -b build.gradle -DcustomProperty=5'
  end
end

describe "Gradle single module"
  before
    let g:test#java#runner = 'gradletest'
    cd spec/fixtures/gradle/java/gradle_single_module
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests (filename matches Test*.java"
    view src/test/java/TestMath.java
    TestFile

    Expect g:test#last_command == 'gradle test --tests TestMath'
  end

  it "runs file tests (filename matches *Test.java)"
    view  src/test/java/MathTest.java
    TestFile

    Expect g:test#last_command == 'gradle test --tests MathTest'
  end

  it "runs file tests (filename matches *Tests.java)"
    view  src/test/java/MathTests.java
    TestFile

    Expect g:test#last_command == 'gradle test --tests MathTests'
  end

  it "runs file tests (filename matches *TestCase.java)"
    view  src/test/java/MathTestCase.java
    TestFile

    Expect g:test#last_command == 'gradle test --tests MathTestCase'
  end

  it "runs file tests with user provided options"
    view  src/test/java/MathTest.java
    TestFile -b build.gradle

    Expect g:test#last_command == 'gradle test -b build.gradle --tests MathTest'
  end

  it "runs nearest tests"
    view +37  src/test/java/MathTest.java
    TestNearest

    Expect g:test#last_command == "gradle test --tests MathTest.testFailedAdd"
  end

  it "runs a suite"
    view  src/test/java/MathTest.java
    TestSuite

    Expect g:test#last_command == 'gradle test'
  end

  it "runs a test suite with user provided options"
    view  src/test/java/MathTest.java
    TestSuite --info -b build.gradle -DcustomProperty=5

    Expect g:test#last_command == 'gradle test --info -b build.gradle -DcustomProperty=5'
  end
end

describe "Gradle multi module"
  before
    let g:test#java#runner = 'gradletest'
    cd spec/fixtures/gradle/java/gradle_multi_module
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests (filename matches Test*.java)"
    view  sample_module/src/test/java/TestMath.java
    TestFile

    Expect g:test#last_command == 'gradle test --tests TestMath -p sample_module'
  end

  it "runs file tests (filename matches *Test.java)"
    view sample_module/src/test/java/MathTest.java
    TestFile

    Expect g:test#last_command == 'gradle test --tests MathTest -p sample_module'
  end

  it "runs file tests (filename matches *Tests.java)"
    view sample_module/src/test/java/MathTests.java
    TestFile

    Expect g:test#last_command == 'gradle test --tests MathTests -p sample_module'
  end

  it "runs file tests (filename matches *TestCase.java)"
    view sample_module/src/test/java/MathTestCase.java
    TestFile

    Expect g:test#last_command == 'gradle test --tests MathTestCase -p sample_module'
  end

  it "runs file tests with user provided options"
    view sample_module/src/test/java/MathTest.java
    TestFile -b build.gradle

    Expect g:test#last_command == 'gradle test -b build.gradle --tests MathTest -p sample_module'
  end

  it "runs nearest tests"
    view +37 sample_module/src/test/java/MathTest.java
    TestNearest

    Expect g:test#last_command == "gradle test --tests MathTest.testFailedAdd -p sample_module"
  end

  it "runs a suite"
    view sample_module/src/test/java/MathTest.java
    TestSuite

    Expect g:test#last_command == 'gradle test  -p sample_module'
  end

  it "runs a test suite with user provided options"
    view sample_module/src/test/java/MathTest.java
    TestSuite --info -b build.gradle -DcustomProperty=5

    Expect g:test#last_command == 'gradle test --info -b build.gradle -DcustomProperty=5  -p sample_module'
  end
end
