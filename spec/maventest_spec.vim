source spec/support/helpers.vim

describe "Maven"

  before
    cd spec/fixtures/maven
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests"
    view MathTest.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=MathTest'
  end

  it "runs nearest tests"
    view +37 MathTest.java
    TestNearest

    Expect g:test#last_command == "mvn test -Dtest=MathTest\\#testFailedAdd"
  end

end
