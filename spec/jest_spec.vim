source spec/support/helpers.vim

describe "Jest"

  before
    cd spec/fixtures/jest
  end

  after
    call Teardown()
    cd -
  end

  context "on nearest tests"
    it "runs JavaScript"
      view +1 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'jest --runTestsByPath -t ''^Math'' -- __tests__/normal-test.js'

      view +2 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'jest --runTestsByPath -t ''^Math Addition'' -- __tests__/normal-test.js'

      view +3 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'jest --runTestsByPath -t ''^Math Addition adds two numbers$'' -- __tests__/normal-test.js'
    end

    it "runs loop tests"
      view +1 __tests__/loop-test.js
      TestNearest

      Expect g:test#last_command == 'jest --runTestsByPath -t ''Loop the test with given array$'' -- __tests__/loop-test.js'

      view +2 __tests__/loop-test.js
      TestNearest

      Expect g:test#last_command == 'jest --runTestsByPath -t ''loop each tests$'' -- __tests__/loop-test.js'

      view +3 __tests__/loop-test.js
      TestNearest

      Expect g:test#last_command == 'jest --runTestsByPath -t ''described loop test$'' -- __tests__/loop-test.js'
    end

    it "aliases context to describe"
      view +1 __tests__/context-test.js
      TestNearest

      Expect g:test#last_command == 'jest --runTestsByPath -t ''^Math'' -- __tests__/context-test.js'

      view +2 __tests__/context-test.js
      TestNearest

      Expect g:test#last_command == 'jest --runTestsByPath -t ''^Math Addition'' -- __tests__/context-test.js'

      view +3 __tests__/context-test.js
      TestNearest

      Expect g:test#last_command == 'jest --runTestsByPath -t ''^Math Addition adds two numbers$'' -- __tests__/context-test.js'

      view +2 __tests__/escaping-test.js
      TestNearest

      Expect g:test#last_command == 'jest --runTestsByPath -t ''^Escaping parentheses \\($'' -- __tests__/escaping-test.js'

      view +5 __tests__/escaping-test.js
      TestNearest

      Expect g:test#last_command == 'jest --runTestsByPath -t ''^Escaping brackets \\[$'' -- __tests__/escaping-test.js'
    end

    it "runs CoffeeScript"
      view +1 __tests__/normal-test.coffee
      TestNearest

      Expect g:test#last_command == 'jest --runTestsByPath -t ''^Math'' -- __tests__/normal-test.coffee'

      view +2 __tests__/normal-test.coffee
      TestNearest

      Expect g:test#last_command == 'jest --runTestsByPath -t ''^Math Addition'' -- __tests__/normal-test.coffee'

      view +3 __tests__/normal-test.coffee
      TestNearest

      Expect g:test#last_command == 'jest --runTestsByPath -t ''^Math Addition adds two numbers$'' -- __tests__/normal-test.coffee'
    end

    it "runs React"
      view +1 __tests__/normal-test.jsx
      TestNearest

      Expect g:test#last_command == 'jest --runTestsByPath -t ''^Math'' -- __tests__/normal-test.jsx'

      view +2 __tests__/normal-test.jsx
      TestNearest

      Expect g:test#last_command == 'jest --runTestsByPath -t ''^Math Addition'' -- __tests__/normal-test.jsx'

      view +3 __tests__/normal-test.jsx
      TestNearest

      Expect g:test#last_command == 'jest --runTestsByPath -t ''^Math Addition adds two numbers$'' -- __tests__/normal-test.jsx'
    end
  end

  it "runs file test if nearest test couldn't be found"
    view +1 __tests__/normal-test.js
    normal O
    TestNearest

    Expect g:test#last_command == 'jest --runTestsByPath -- __tests__/normal-test.js'
  end

  it "runs file tests"
    view +1 __tests__/normal-test.js
    TestFile

    Expect g:test#last_command == 'jest --runTestsByPath -- __tests__/normal-test.js'

    view +2 __tests__/(folder)/normal-test.js
    TestFile

    Expect g:test#last_command == 'jest --runTestsByPath -- __tests__/\(folder\)/normal-test.js'
  end

  it "runs test suites"
    view __tests__/normal-test.js
    TestSuite

    Expect g:test#last_command == 'jest'
  end

  it "runs tests outside of __tests__"
    view outside-test.js
    TestFile

    Expect g:test#last_command == 'jest --runTestsByPath -- outside-test.js'
  end

  context "with a specified executable"
    after
      unlet g:test#javascript#jest#executable
    end

    it "runs tests against npm executable"
      let g:test#javascript#jest#executable = 'npm run jest'
      view __tests__/normal-test.js
      TestFile

      Expect g:test#last_command == 'npm run jest --runTestsByPath -- __tests__/normal-test.js'
    end

    it "runs tests against yarn executable (without --)"
      let g:test#javascript#jest#executable = 'yarn jest'
      view __tests__/normal-test.js
      TestFile

      Expect g:test#last_command == 'yarn jest --runTestsByPath __tests__/normal-test.js'
    end

    it "runs tests against absolute path yarn executable (without --)"
      let g:test#javascript#jest#executable = '~/.local/bin/yarn jest'
      view __tests__/normal-test.js
      TestFile

      Expect g:test#last_command == '~/.local/bin/yarn jest --runTestsByPath __tests__/normal-test.js'
    end
  end

end
