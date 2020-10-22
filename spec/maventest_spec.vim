source spec/support/helpers.vim

" add the integrationtest command for java files
command! -nargs=* -bar IntegrationTest call test#run('integration', split(<q-args>))

describe "Maven Junit3 tests"

  before
    cd spec/fixtures/maven/sample_maven_junit3_project
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests (filename matches Test*.java)"
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

    Expect g:test#last_command == 'mvn -f pom.xml test -Dtest=org.vimtest.math.MathTest\*'
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

    Expect g:test#last_command == 'mvn -X -f pom.xml -DcustomProperty=5 test'
  end


end

describe "Maven Junit3 multimodule tests"

  before
    cd spec/fixtures/maven/sample_maven_junit3_multimodule_project
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests (filename matches Test*.java)"
    view sample_module/src/test/java/org/vimtest/math/TestMath.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.math.TestMath\* -pl sample_module'
  end

  it "runs file tests (filename matches *Test.java)"
    view sample_module/src/test/java/org/vimtest/math/MathTest.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.math.MathTest\* -pl sample_module'
  end

  it "runs file tests (filename matches *Tests.java)"
    view sample_module/src/test/java/org/vimtest/math/MathTests.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.math.MathTests\* -pl sample_module'
  end

  it "runs file tests (filename matches *TestCase.java)"
    view sample_module/src/test/java/org/vimtest/math/MathTestCase.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.math.MathTestCase\* -pl sample_module'
  end

  it "runs file tests with user provided options"
    view sample_module/src/test/java/org/vimtest/math/MathTest.java
    TestFile -f pom.xml

    Expect g:test#last_command == 'mvn -f pom.xml test -Dtest=org.vimtest.math.MathTest\* -pl sample_module'
  end

  it "runs nearest tests"
    view +37 sample_module/src/test/java/org/vimtest/math/MathTest.java
    TestNearest

    Expect g:test#last_command == "mvn test -Dtest=org.vimtest.math.MathTest\\#testFailedAdd -pl sample_module"
  end

  it "runs a suite"
    view sample_module/src/test/java/org/vimtest/math/MathTest.java
    TestSuite

    Expect g:test#last_command == 'mvn test -pl sample_module'
  end

  it "runs a test suite with user provided options"
    view sample_module/src/test/java/org/vimtest/math/MathTest.java
    TestSuite -X -f pom.xml -DcustomProperty=5

    Expect g:test#last_command == 'mvn -X -f pom.xml -DcustomProperty=5 test -pl sample_module'
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

describe "Maven Junit5 multimodule tests"

  before
    cd spec/fixtures/maven/sample_maven_junit5_multimodule_project
  end

  after
    call Teardown()
    cd -
  end

  it "TestFile runs with package-path, with asterisk to catch nested-test-classes"
    view +14 sample_module/src/test/java/org/vimtest/TestApp.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\* -pl sample_module'
  end

  it "TestNearest - @Test void func()"
    view +12 sample_module/src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\#test_testdecorator_void -pl sample_module'
  end

  it "TestNearest - @Test public void func()"
    view +17 sample_module/src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\#test_testdecorator_public_void -pl sample_module'
  end

  it "TestNearest - void func()"
    view +22 sample_module/src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\#test_void -pl sample_module'
  end

  it "TestNearest - public void func()"
    view +30 sample_module/src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\#test_public_void -pl sample_module'
  end

  it "TestNearest - nested test()"
    view +39 sample_module/src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\$Test_NestedTestClass\#test_nested_test -pl sample_module'
  end

end

describe "Integration tests single module"

  before
    cd spec/fixtures/maven/sample_maven_junit5_project
  end

  after
    call Teardown()
    cd -
  end

  it "IntegrationTest runs with verify without fully qualified classname"
    view +14 src/test/java/org/vimtest/TestApp.java
    IntegrationTest

    Expect g:test#last_command == 'mvn verify -Dit.test=TestApp\*'
  end
end
describe "Integration tests multi module"

  before
    cd spec/fixtures/maven/sample_maven_junit5_multimodule_project
  end

  after
    call Teardown()
    cd -
  end

  it "IntegrationTest runs with verify without fully qualified classname in the module"
    view +14 sample_module/src/test/java/org/vimtest/TestApp.java
    IntegrationTest

    Expect g:test#last_command == 'mvn verify -Dit.test=TestApp\* -pl sample_module'
  end
end
