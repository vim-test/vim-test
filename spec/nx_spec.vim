source spec/support/helpers.vim

describe "Nx"

  after
    call Teardown()
    cd -
  end

  context "on nearest tests"
    it "runs JavaScript"
      view +1 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math'' -- __tests__/normal-test.js'

      view +2 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math Addition'' -- __tests__/normal-test.js'

      view +3 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math Addition adds two numbers$'' -- __tests__/normal-test.js'
    end

    it "aliases context to describe"
      view +1 __tests__/context-test.js
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math'' -- __tests__/context-test.js'

      view +2 __tests__/context-test.js
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math Addition'' -- __tests__/context-test.js'

      view +3 __tests__/context-test.js
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math Addition adds two numbers$'' -- __tests__/context-test.js'
    end

    it "runs CoffeeScript"
      view +1 __tests__/normal-test.coffee
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math'' -- __tests__/normal-test.coffee'

      view +2 __tests__/normal-test.coffee
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math Addition'' -- __tests__/normal-test.coffee'

      view +3 __tests__/normal-test.coffee
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math Addition adds two numbers$'' -- __tests__/normal-test.coffee'
    end

    it "runs React"
      view +1 __tests__/normal-test.jsx
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math'' -- __tests__/normal-test.jsx'

      view +2 __tests__/normal-test.jsx
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math Addition'' -- __tests__/normal-test.jsx'

      view +3 __tests__/normal-test.jsx
      TestNearest

      Expect g:test#last_command == 'nx test -t ''^Math Addition adds two numbers$'' -- __tests__/normal-test.jsx'
    end
  end

  it "runs file test if nearest test couldn't be found"
    view +1 __tests__/normal-test.js
    normal O
    TestNearest

    Expect g:test#last_command == 'nx test -- __tests__/normal-test.js'
  end

  it "runs file tests"
    view __tests__/normal-test.js
    TestFile

    Expect g:test#last_command == 'nx test -- __tests__/normal-test.js'
  end

  it "runs test suites"
    view __tests__/normal-test.js
    TestSuite

    Expect g:test#last_command == 'jest'
  end

  it "runs tests outside of __tests__"
    view outside-test.js
    TestFile

    Expect g:test#last_command == 'nx test -- outside-test.js'
  end

  context "with a specified executable"
    after
      unlet g:test#javascript#jest#executable
    end

    it "runs tests against npm executable"
      let g:test#javascript#jest#executable = 'npm run jest'
      view __tests__/normal-test.js
      TestFile

      Expect g:test#last_command == 'npm run nx test -- __tests__/normal-test.js'
    end

    it "runs tests against yarn executable (without --)"
      let g:test#javascript#jest#executable = 'yarn jest'
      view __tests__/normal-test.js
      TestFile

      Expect g:test#last_command == 'yarn nx test __tests__/normal-test.js'
    end

    it "runs tests against absolute path yarn executable (without --)"
      let g:test#javascript#jest#executable = '~/.local/bin/yarn jest'
      view __tests__/normal-test.js
      TestFile

      Expect g:test#last_command == '~/.local/bin/yarn nx test __tests__/normal-test.js'
    end
  end

end
