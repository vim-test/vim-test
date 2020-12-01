source spec/support/helpers.vim

describe "Gradle plain module"
  before
    cd spec/fixtures/gradle/kotlin/gradle_plain
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests (filename matches Test*.kt)"
    view TestMath.kt
    TestFile

    Expect g:test#last_command == './gradlew test --tests TestMath'
  end

  it "runs file tests (filename matches *Test.kt)"
    view  CalculationTest.kt
    TestFile

    Expect g:test#last_command == './gradlew test --tests CalculationTest'
  end

  it "runs file tests (filename matches *Tests.kt)"
    view  CalculationTests.kt
    TestFile

    Expect g:test#last_command == './gradlew test --tests CalculationTests'
  end

  it "runs file tests (filename matches *TestCase.kt)"
    view  CalculationTestCase.kt
    TestFile

    Expect g:test#last_command == './gradlew test --tests CalculationTestCase'
  end

  it "runs file tests with user provided options"
    view  CalculationTest.kt
    TestFile -b build.gradle

    Expect g:test#last_command == './gradlew test -b build.gradle --tests CalculationTest'
  end

  it "runs nearest tests"
    view +37  CalculationTest.kt
    TestNearest

    Expect g:test#last_command == "./gradlew test --tests CalculationTest.testFailedSub"
  end

  it "runs a suite"
    view  CalculationTest.kt
    TestSuite

    Expect g:test#last_command == './gradlew test'
  end

  it "runs a test suite with user provided options"
    view  CalculationTest.kt
    TestSuite --info -b build.gradle -DcustomProperty=5

    Expect g:test#last_command == './gradlew test --info -b build.gradle -DcustomProperty=5'
  end
end
describe "Gradle single module"
  before
    cd spec/fixtures/gradle/kotlin/gradle_single_module
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests (filename matches Test*.kt)"
    view src/test/kotlin/TestCalculation.kt
    TestFile

    Expect g:test#last_command == './gradlew test --tests TestCalculation'
  end

  it "runs file tests (filename matches *Test.kt)"
    view  src/test/kotlin/CalculationTest.kt
    TestFile

    Expect g:test#last_command == './gradlew test --tests CalculationTest'
  end

  it "runs file tests (filename matches *Tests.kt)"
    view  src/test/kotlin/CalculationTests.kt
    TestFile

    Expect g:test#last_command == './gradlew test --tests CalculationTests'
  end

  it "runs file tests (filename matches *TestCase.kt)"
    view  src/test/kotlin/CalculationTestCase.kt
    TestFile

    Expect g:test#last_command == './gradlew test --tests CalculationTestCase'
  end

  it "runs file tests with user provided options"
    view  src/test/kotlin/CalculationTest.kt
    TestFile -b build.gradle

    Expect g:test#last_command == './gradlew test -b build.gradle --tests CalculationTest'
  end

  it "runs nearest tests"
    view +37  src/test/kotlin/CalculationTest.kt
    TestNearest

    Expect g:test#last_command == "./gradlew test --tests CalculationTest.testFailedSub"
  end

  it "runs a suite"
    view  src/test/kotlin/CalculationTest.kt
    TestSuite

    Expect g:test#last_command == './gradlew test'
  end

  it "runs a test suite with user provided options"
    view  src/test/kotlin/CalculationTest.kt
    TestSuite --info -b build.gradle -DcustomProperty=5

    Expect g:test#last_command == './gradlew test --info -b build.gradle -DcustomProperty=5'
  end
end

describe "Gradle muilti module"
  before
    cd spec/fixtures/gradle/kotlin/gradle_multi_module
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests (filename matches Test*.kt)"
    view sample_module/src/test/kotlin/TestCalculation.kt
    TestFile

    Expect g:test#last_command == './gradlew test --tests TestCalculation -p sample_module'
  end

  it "runs file tests (filename matches *Test.kt)"
    view  sample_module/src/test/kotlin/CalculationTest.kt
    TestFile

    Expect g:test#last_command == './gradlew test --tests CalculationTest -p sample_module'
  end

  it "runs file tests (filename matches *Tests.kt)"
    view  sample_module/src/test/kotlin/CalculationTests.kt
    TestFile

    Expect g:test#last_command == './gradlew test --tests CalculationTests -p sample_module'
  end

  it "runs file tests (filename matches *TestCase.kt)"
    view  sample_module/src/test/kotlin/CalculationTestCase.kt
    TestFile

    Expect g:test#last_command == './gradlew test --tests CalculationTestCase -p sample_module'
  end

  it "runs file tests with user provided options"
    view  sample_module/src/test/kotlin/CalculationTest.kt
    TestFile -b build.gradle

    Expect g:test#last_command == './gradlew test -b build.gradle --tests CalculationTest -p sample_module'
  end

  it "runs nearest tests"
    view +37  sample_module/src/test/kotlin/CalculationTest.kt
    TestNearest

    Expect g:test#last_command == "./gradlew test --tests CalculationTest.testFailedSub -p sample_module"
  end

  it "runs a suite"
    view  sample_module/src/test/kotlin/CalculationTest.kt
    TestSuite

    Expect g:test#last_command == './gradlew test  -p sample_module'
  end

  it "runs a test suite with user provided options"
    view  sample_module/src/test/kotlin/CalculationTest.kt
    TestSuite --info -b build.gradle -DcustomProperty=5

    Expect g:test#last_command == './gradlew test --info -b build.gradle -DcustomProperty=5  -p sample_module'
  end
end
