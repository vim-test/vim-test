source spec/support/helpers.vim

describe "Angular ng-test"

  before
    cd spec/fixtures/angular
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests from top"
    view e2e/src/app.e2e-spec.ts
    TestNearest

    Expect g:test#last_command == "ng test --include='e2e/src/app.e2e-spec.ts'"
  end

  it "runs nearest tests inside describe block"
    view +5 e2e/src/app.e2e-spec.ts
    TestNearest

    Expect g:test#last_command == "ng test --include='e2e/src/app.e2e-spec.ts' --filter='workspace-project App'"
  end

  it "runs nearest tests inside it block"
    view +11 e2e/src/app.e2e-spec.ts
    TestNearest

    Expect g:test#last_command == "ng test --include='e2e/src/app.e2e-spec.ts' --filter='workspace-project App should display welcome message'"
  end

  it "runs file tests"
    view e2e/src/app.e2e-spec.ts
    TestFile

    Expect g:test#last_command == "ng test --include='e2e/src/app.e2e-spec.ts'"
  end

  it "runs test suites"
    view e2e/src/app.e2e-spec.ts
    TestSuite

    Expect g:test#last_command == 'ng test'
  end

end
