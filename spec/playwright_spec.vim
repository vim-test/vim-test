source spec/support/helpers.vim

describe "Playwright"

  before
    cd spec/fixtures/playwright
	!mkdir node_modules
	!mkdir node_modules/.bin
  end

  after
    !rm -f node_modules/.bin/*
    call Teardown()
    cd -
  end

  context "on nearest tests"
    it "runs    JavaScript"
      view +3 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'playwright test -g ''Math'' __tests__/normal-test.js'

      view +4 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'playwright test -g ''Math Addition'' __tests__/normal-test.js'

      view +5 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'playwright test -g ''Math Addition adds two numbers'' __tests__/normal-test.js'
    end
  end

  it "runs file test if nearest test couldn't be found"
    view +1 __tests__/normal-test.js
    normal O
    TestNearest

    Expect g:test#last_command == 'playwright test __tests__/normal-test.js'
  end

  it "runs file tests"
    view __tests__/normal-test.js
    TestFile

    Expect g:test#last_command == 'playwright test __tests__/normal-test.js'
  end

  it "runs test suites"
    view __tests__/normal-test.js
    TestSuite

    Expect g:test#last_command == 'playwright test'
  end

  it "runs tests outside of __tests__"
    view outside-test.js
    TestFile

    Expect g:test#last_command == 'playwright test outside-test.js'
  end

  context "with a specified executable"
    after
      unlet g:test#javascript#playwright#executable
    end

    it "runs tests against npm executable"
      let g:test#javascript#playwright#executable = 'npm run playwright test'
      view __tests__/normal-test.js
      TestFile

      Expect g:test#last_command == 'npm run playwright test __tests__/normal-test.js'
    end

    it "runs tests against yarn executable (without)"
      let g:test#javascript#playwright#executable = 'yarn playwright test'
      view __tests__/normal-test.js
      TestFile

      Expect g:test#last_command == 'yarn playwright test __tests__/normal-test.js'
    end

    it "runs tests against absolute path yarn executable (without)"
      let g:test#javascript#playwright#executable = '~/.local/bin/yarn playwright test'
      view __tests__/normal-test.js
      TestFile

      Expect g:test#last_command == '~/.local/bin/yarn playwright test __tests__/normal-test.js'
    end
  end

end
