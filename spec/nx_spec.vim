source spec/support/helpers.vim

describe "Nx"

  before
    cd spec/fixtures/nx
  end

  after
    call Teardown()
    cd -
  end

  context "on nearest tests"
    it "runs JavaScript"
      view +1 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math'' --test-file __tests__/normal-test.js'

      view +2 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math Addition'' --test-file __tests__/normal-test.js'

      view +3 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math Addition adds two numbers$'' --test-file __tests__/normal-test.js'
    end

    it "aliases context to describe"
      view +1 __tests__/context-test.js
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math'' --test-file __tests__/context-test.js'

      view +2 __tests__/context-test.js
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math Addition'' --test-file __tests__/context-test.js'

      view +3 __tests__/context-test.js
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math Addition adds two numbers$'' --test-file __tests__/context-test.js'
    end

    it "runs CoffeeScript"
      view +1 __tests__/normal-test.coffee
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math'' --test-file __tests__/normal-test.coffee'

      view +2 __tests__/normal-test.coffee
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math Addition'' --test-file __tests__/normal-test.coffee'

      view +3 __tests__/normal-test.coffee
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math Addition adds two numbers$'' --test-file __tests__/normal-test.coffee'
    end

    it "runs React"
      view +1 __tests__/normal-test.jsx
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math'' --test-file __tests__/normal-test.jsx'

      view +2 __tests__/normal-test.jsx
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math Addition'' --test-file __tests__/normal-test.jsx'

      view +3 __tests__/normal-test.jsx
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math Addition adds two numbers$'' --test-file __tests__/normal-test.jsx'
    end
  end

  it "references the project when project.json is used"
    view +1 apps/backend/normal-test.js
    TestNearest

    Expect g:test#last_command == 'nx test backend -t ''^Math'' --test-file apps/backend/normal-test.js'
  end

  it "references the project when workspace.json is used"
    view +1 apps/products/normal-test.jsx
    TestNearest

    Expect g:test#last_command == 'nx test products -t ''^Math'' --test-file apps/products/normal-test.jsx'
  end

  it "runs file test if nearest test couldn't be found"
    view +1 __tests__/normal-test.js
    normal O
    TestNearest

    Expect g:test#last_command == 'nx test --test-file __tests__/normal-test.js'
  end

  it "runs file tests"
    view __tests__/normal-test.js
    TestFile

    Expect g:test#last_command == 'nx test --test-file __tests__/normal-test.js'
  end

  it "runs test suites"
    view __tests__/normal-test.js
    TestSuite

    Expect g:test#last_command == 'nx test'
  end

  context "with a set project"
    after
      unlet g:test#javascript#nx#project
    end

    it "runs file tests"
      let g:test#javascript#nx#project = 'app'
      view __tests__/normal-test.js
      TestFile

      Expect g:test#last_command == 'nx test app --test-file __tests__/normal-test.js'
    end

    it "runs test suites"
      let g:test#javascript#nx#project = 'api'
      view __tests__/normal-test.js
      TestSuite

      Expect g:test#last_command == 'nx test api'
    end
  end

  it "runs tests outside of __tests__"
    view outside-test.js
    TestFile

    Expect g:test#last_command == 'nx test --test-file outside-test.js'
  end

  context "with a specified executable"
    after
      unlet g:test#javascript#nx#executable
    end

    it "runs tests against npm executable"
      let g:test#javascript#nx#executable = 'npm run nx'
      view __tests__/normal-test.js
      TestFile

      Expect g:test#last_command == 'npm run nx --test-file __tests__/normal-test.js'
    end

    it "runs tests against yarn executable (without --)"
      let g:test#javascript#nx#executable = 'yarn nx'
      view __tests__/normal-test.js
      TestFile

      Expect g:test#last_command == 'yarn nx --test-file __tests__/normal-test.js'
    end

    it "runs tests against absolute path yarn executable (without --)"
      let g:test#javascript#nx#executable = '~/.local/bin/yarn nx'
      view __tests__/normal-test.js
      TestFile

      Expect g:test#last_command == '~/.local/bin/yarn nx --test-file __tests__/normal-test.js'
    end
  end

end
