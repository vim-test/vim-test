source spec/support/helpers.vim

describe "Maven"

  before
    cd spec/fixtures/maven
  end

  after
    unlet! g:test#java#maventest#options
    call Teardown()
    cd -
  end

  it "runs file tests"
    view MathTest.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=MathTest'
  end

  it "runs file tests with user provided options"
    view MathTest.java
    let g:test#java#maventest#options = '-f pom.xml'
    TestFile

    Expect g:test#last_command == 'mvn test -f pom.xml -Dtest=MathTest'
  end

  it "runs nearest tests"
    view +37 MathTest.java
    TestNearest

    Expect g:test#last_command == "mvn test -Dtest=MathTest\\#testFailedAdd"
  end

  it "runs a suite"
    view MathTest.java
    TestSuite

    Expect g:test#last_command == 'mvn test'
  end

  it "runs a test suite with user provided options"
    view MathTest.java
    let g:test#java#maventest#options = '-X -f pom.xml -DcustomProperty=5'
    TestSuite

    Expect g:test#last_command == 'mvn test -X -f pom.xml -DcustomProperty=5'
  end

end
