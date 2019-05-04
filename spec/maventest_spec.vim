source spec/support/helpers.vim

describe "Maven Junit3 tests"

  before
    cd spec/fixtures/maven/sample_maven_junit3_project
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests (filename matches Test*.java"
    view src/test/java/org/vimtest/math/TestMath.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.math.TestMath\*'
  end

  it "runs file tests (filename matches *Test.java)"
    view src/test/java/org/vimtest/math/MathTest.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.math.MathTest\*'
  end

  it "runs file tests (filename matches *Tests.java)"
    view src/test/java/org/vimtest/math/MathTests.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.math.MathTests\*'
  end

  it "runs file tests (filename matches *TestCase.java)"
    view src/test/java/org/vimtest/math/MathTestCase.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.math.MathTestCase\*'
  end

  it "runs file tests with user provided options"
    view src/test/java/org/vimtest/math/MathTest.java
    TestFile -f pom.xml

    Expect g:test#last_command == 'mvn test -f pom.xml -Dtest=org.vimtest.math.MathTest\*'
  end

  it "runs nearest tests"
    view +37 src/test/java/org/vimtest/math/MathTest.java
    TestNearest

    Expect g:test#last_command == "mvn test -Dtest=org.vimtest.math.MathTest\\#testFailedAdd"
  end

  it "runs a suite"
    view src/test/java/org/vimtest/math/MathTest.java
    TestSuite

    Expect g:test#last_command == 'mvn test'
  end

  it "runs a test suite with user provided options"
    view src/test/java/org/vimtest/math/MathTest.java
    TestSuite -X -f pom.xml -DcustomProperty=5

    Expect g:test#last_command == 'mvn test -X -f pom.xml -DcustomProperty=5'
  end


end


describe "Maven Junit5 tests"

  before
    cd spec/fixtures/maven/sample_maven_junit5_project
  end

  after
    call Teardown()
    cd -
  end

  it "TestFile runs with package-path, with asterisk to catch nested-test-classes"
    view +14 src/test/java/org/vimtest/TestApp.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\*'
  end

  it "TestNearest - @Test void func()"
    view +12 src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\#test_testdecorator_void'
  end

  it "TestNearest - @Test public void func()"
    view +17 src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\#test_testdecorator_public_void'
  end

  it "TestNearest - void func()"
    view +22 src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\#test_void'
  end

  it "TestNearest - public void func()"
    view +30 src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\#test_public_void'
  end

  it "TestNearest - nested test()"
    view +39 src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\$Test_NestedTestClass\#test_nested_test'
  end

end

