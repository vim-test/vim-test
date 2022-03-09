source spec/support/helpers.vim

describe "Gradle Groovy/Spock single module"
  before
    let g:test#groovy#runner = 'gradletest'
    cd spec/fixtures/gradle/groovy/gradle_spock_single_module
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests (filename matches *Spec.groovy)"
    view src/test/groovy/DataDrivenSpec.groovy
    TestFile

    Expect g:test#last_command == './gradlew test --tests DataDrivenSpec -p .'
  end

  it "runs file tests with user provided options"
    view src/test/groovy/DatabaseDrivenSpec.groovy
    TestFile -b build.gradle
  
    Expect g:test#last_command == './gradlew test -b build.gradle --tests DatabaseDrivenSpec -p .'
  end
  
  it "runs nearest tests"
    view +31 src/test/groovy/DataDrivenSpec.groovy
    TestNearest
  
    Expect g:test#last_command == "./gradlew test --tests DataDrivenSpec.\"minimum of #a and #b is #c\" -p ."
  end
  
  it "runs a suite"
    view src/test/groovy/HelloSpockSpec.groovy
    TestSuite
  
    Expect g:test#last_command == './gradlew test -p .'
  end
  
  it "runs a test suite with user provided options"
    view src/test/groovy/HelloSpockSpec.groovy
    TestSuite --info -b build.gradle -DcustomProperty=5
  
    Expect g:test#last_command == './gradlew test --info -b build.gradle -DcustomProperty=5 -p .'
  end
end

describe "Gradle Groovy/Spock multi-module"
  before
    let g:test#groovy#runner = 'gradletest'
    cd spec/fixtures/gradle/groovy/gradle_spock_multi_module
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests (filename matches *Spec.groovy)"
    view module_one/src/test/groovy/DataDrivenSpec.groovy
    TestFile

    Expect g:test#last_command == './gradlew test --tests DataDrivenSpec -p module_one'
  end

  it "runs file tests with user provided options"
    view module_one/src/test/groovy/DatabaseDrivenSpec.groovy
    TestFile -b build.gradle
  
    Expect g:test#last_command == './gradlew test -b build.gradle --tests DatabaseDrivenSpec -p module_one'
  end
  
  it "runs nearest tests"
    view +31 module_one/src/test/groovy/DataDrivenSpec.groovy
    TestNearest
  
    Expect g:test#last_command == "./gradlew test --tests DataDrivenSpec.\"minimum of #a and #b is #c\" -p module_one"
  end
  
  it "runs a suite"
    view module_two/src/test/groovy/HelloSpockSpec.groovy
    TestSuite
  
    Expect g:test#last_command == './gradlew test -p module_two'
  end
  
  it "runs a test suite with user provided options"
    view module_two/src/test/groovy/HelloSpockSpec.groovy
    TestSuite --info -b build.gradle -DcustomProperty=5
  
    Expect g:test#last_command == './gradlew test --info -b build.gradle -DcustomProperty=5 -p module_two'
  end
end
