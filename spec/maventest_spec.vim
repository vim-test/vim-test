source spec/support/helpers.vim

describe "Maven"

  before
    cd spec/fixtures/maven
  end

  after
    call Teardown()
    cd -
  end

"  it "runs file tests (filename matches Test*.java"
"    view TestMath.java
"    TestFile
"
"    Expect g:test#last_command == 'mvn test -Dtest=TestMath'
"  end
"
"  it "runs file tests (filename matches *Test.java)"
"    view MathTest.java
"    TestFile
"
"    Expect g:test#last_command == 'mvn test -Dtest=MathTest'
"  end
"
"  it "runs file tests (filename matches *Tests.java)"
"    view MathTests.java
"    TestFile
"
"    Expect g:test#last_command == 'mvn test -Dtest=MathTests'
"  end
"
"  it "runs file tests (filename matches *TestCase.java)"
"    view MathTestCase.java
"    TestFile
"
"    Expect g:test#last_command == 'mvn test -Dtest=MathTestCase'
"  end
"
"  it "runs file tests with user provided options"
"    view MathTest.java
"    TestFile -f pom.xml
"
"    Expect g:test#last_command == 'mvn test -f pom.xml -Dtest=MathTest'
"  end
"
"  it "runs nearest tests"
"    view +37 MathTest.java
"    TestNearest
"
"    Expect g:test#last_command == "mvn test -Dtest=MathTest\\#testFailedAdd"
"  end
"
"  it "runs a suite"
"    view MathTest.java
"    TestSuite
"
"    Expect g:test#last_command == 'mvn test'
"  end
"
"  it "runs a test suite with user provided options"
"    view MathTest.java
"    TestSuite -X -f pom.xml -DcustomProperty=5
"
"    Expect g:test#last_command == 'mvn test -X -f pom.xml -DcustomProperty=5'
"  end


end


describe "MavenProject"

  before
    cd spec/fixtures/maven/junit5_project
  end

  after
    call Teardown()
    cd -
  end

  it "TestFile runs with package-path, with asterisk to catch nested-test-classes"
    view +14 src/test/java/com/example/junit5_project/TestJunit5App.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=com.example.junit5_project.TestJunit5App\*'
  end

  it "TestNearest - @Test void func()"
    view +12 src/test/java/com/example/junit5_project/TestJunit5App.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=com.example.junit5_project.TestJunit5App\#test_testdecorator_void'
  end

  it "TestNearest - @Test public void func()"
    view +17 src/test/java/com/example/junit5_project/TestJunit5App.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=com.example.junit5_project.TestJunit5App\#test_testdecorator_public_void'
  end

  it "TestNearest - void func()"
    view +22 src/test/java/com/example/junit5_project/TestJunit5App.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=com.example.junit5_project.TestJunit5App\#test_void'
  end

  it "TestNearest - public void func()"
    view +30 src/test/java/com/example/junit5_project/TestJunit5App.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=com.example.junit5_project.TestJunit5App\#test_public_void'
  end

  it "TestNearest - nested test()"
    view +39 src/test/java/com/example/junit5_project/TestJunit5App.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=com.example.junit5_project.TestJunit5App\$Test_NestedTestClass\#test_nested_test'
  end

end

