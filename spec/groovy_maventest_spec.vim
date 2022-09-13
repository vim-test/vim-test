source spec/support/helpers.vim

describe "Maven Groovy/Spock single module"
  before
    let g:test#groovy#runner = 'maventest'
    cd spec/fixtures/maven/sample_maven_groovy_spock_project
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests (filename matches *Spec.groovy)"
    view src/test/groovy/org/spockframework/spock/example/DataDrivenSpec.groovy
    TestFile

    Expect g:test#last_command == './mvnw test -Dtest=org.spockframework.spock.example.DataDrivenSpec\* -pl .'
  end

  it "runs file tests with user provided options"
    view src/test/groovy/org/spockframework/spock/example/DatabaseDrivenSpec.groovy
    TestFile -o
  
    Expect g:test#last_command == './mvnw -o test -Dtest=org.spockframework.spock.example.DatabaseDrivenSpec\* -pl .'
  end
  
  it "runs nearest tests"
    view +33 src/test/groovy/org/spockframework/spock/example/DataDrivenSpec.groovy
    TestNearest
  
    Expect g:test#last_command == "./mvnw test -Dtest=org.spockframework.spock.example.DataDrivenSpec#\"minimum of #a and #b is #c\" -pl ."
  end
  
  it "runs a suite"
    view src/test/groovy/org/spockframework/spock/example/HelloSpockSpec.groovy
    TestSuite
  
    Expect g:test#last_command == './mvnw test -pl .'
  end
  
  it "runs a test suite with user provided options"
    view src/test/groovy/org/spockframework/spock/example/HelloSpockSpec.groovy
    TestSuite -o -ff
  
    Expect g:test#last_command == './mvnw -o -ff test -pl .'
  end
end

describe "Maven Groovy/Spock single module (under java package)"
  before
    let g:test#groovy#runner = 'maventest'
    cd spec/fixtures/maven/sample_maven_java_spock_project
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests (filename matches *Spec.groovy)"
    view src/test/java/org/spockframework/spock/example/DataDrivenSpec.groovy
    TestFile

    Expect g:test#last_command == './mvnw test -Dtest=org.spockframework.spock.example.DataDrivenSpec\* -pl .'
  end

  it "runs file tests with user provided options"
    view src/test/java/org/spockframework/spock/example/DatabaseDrivenSpec.groovy
    TestFile -o
  
    Expect g:test#last_command == './mvnw -o test -Dtest=org.spockframework.spock.example.DatabaseDrivenSpec\* -pl .'
  end
  
  it "runs nearest tests"
    view +33 src/test/java/org/spockframework/spock/example/DataDrivenSpec.groovy
    TestNearest
  
    Expect g:test#last_command == "./mvnw test -Dtest=org.spockframework.spock.example.DataDrivenSpec#\"minimum of #a and #b is #c\" -pl ."
  end
  
  it "runs a suite"
    view src/test/java/org/spockframework/spock/example/HelloSpockSpec.groovy
    TestSuite
  
    Expect g:test#last_command == './mvnw test -pl .'
  end
  
  it "runs a test suite with user provided options"
    view src/test/java/org/spockframework/spock/example/HelloSpockSpec.groovy
    TestSuite -o -ff
  
    Expect g:test#last_command == './mvnw -o -ff test -pl .'
  end
end

describe "Maven Groovy/Spock multi-module"
  before
    let g:test#groovy#runner = 'maventest'
    cd spec/fixtures/maven/sample_maven_groovy_spock_multimodule_project
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests (filename matches *Spec.groovy)"
    view module_one/src/test/groovy/org/spockframework/spock/example/DataDrivenSpec.groovy
    TestFile
  
    Expect g:test#last_command == './mvnw test -Dtest=org.spockframework.spock.example.DataDrivenSpec\* -pl module_one'
  end
  
  it "runs file tests with user provided options"
    view module_one/src/test/groovy/org/spockframework/spock/example/DatabaseDrivenSpec.groovy
    TestFile -o
  
    Expect g:test#last_command == './mvnw -o test -Dtest=org.spockframework.spock.example.DatabaseDrivenSpec\* -pl module_one'
  end
  
  it "runs nearest tests"
    view +33 module_one/src/test/groovy/org/spockframework/spock/example/DataDrivenSpec.groovy
    TestNearest
  
    Expect g:test#last_command == "./mvnw test -Dtest=org.spockframework.spock.example.DataDrivenSpec#\"minimum of #a and #b is #c\" -pl module_one"
  end
  
  it "runs a suite"
    view module_two/src/test/groovy/org/spockframework/spock/example/HelloSpockSpec.groovy
    TestSuite
  
    Expect g:test#last_command == './mvnw test -pl module_two'
  end
  
  it "runs a test suite with user provided options"
    view module_two/src/test/groovy/org/spockframework/spock/example/HelloSpockSpec.groovy
    TestSuite -o -ff
  
    Expect g:test#last_command == './mvnw -o -ff test -pl module_two'
  end
end
