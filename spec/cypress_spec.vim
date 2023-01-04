source spec/support/helpers.vim

describe "Cypress"

  before
    cd spec/fixtures/cypress
  end

  after
    call Teardown()
    cd -
  end

  it "runs spec file tests"
    view integration_tests/normal.spec.js
    TestFile

    Expect g:test#last_command == 'cypress run --spec integration_tests/normal.spec.js'
  end

  it "runs cy file tests"
    view integration_tests/normal.cy.js
    TestFile

    Expect g:test#last_command == 'cypress run --spec integration_tests/normal.cy.js'
  end

  it "runs test file tests"
    view integration_tests/normal.test.js
    TestFile

    Expect g:test#last_command == 'cypress run --spec integration_tests/normal.test.js'
  end

  it "runs test suites"
    view integration_tests/normal.spec.js
    TestSuite

    Expect g:test#last_command == 'cypress run'
  end

  it "runs tests outside of integration_tests"
    view outside.spec.js
    TestFile

    Expect g:test#last_command == 'cypress run --spec outside.spec.js'
  end

  context "with a specified executable"
    after
      unlet g:test#javascript#cypress#executable
    end

    it "runs tests against npm executable"
      let g:test#javascript#cypress#executable = 'npm run cypress'
      view integration_tests/normal.spec.js
      TestFile

      Expect g:test#last_command == 'npm run cypress run --spec integration_tests/normal.spec.js'
    end

    it "runs tests against yarn executable (without --)"
      let g:test#javascript#cypress#executable = 'yarn cypress'
      view integration_tests/normal.spec.js
      TestFile

      Expect g:test#last_command == 'yarn cypress run --spec integration_tests/normal.spec.js'
    end

    it "runs tests against absolute path yarn executable (without --)"
      let g:test#javascript#cypress#executable = '~/.local/bin/yarn cypress'
      view integration_tests/normal.spec.js
      TestFile

      Expect g:test#last_command == '~/.local/bin/yarn cypress run --spec integration_tests/normal.spec.js'
    end
  end

end
