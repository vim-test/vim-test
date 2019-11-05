source spec/support/helpers.vim

describe "Angular ng-test"

  before
    cd spec/fixtures/angular
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view e2e/src/app.e2e-spec.ts
    TestNearest

    Expect g:test#last_command == 'ng test'
  end

  it "runs file tests"
    view e2e/src/app.e2e-spec.ts
    TestFile

    Expect g:test#last_command == 'ng test'
  end

  it "runs test suites"
    view e2e/src/app.e2e-spec.ts
    TestSuite

    Expect g:test#last_command == 'ng test'
  end

end
