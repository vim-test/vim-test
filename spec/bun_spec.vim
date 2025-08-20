source spec/support/helpers.vim

describe "BunTest"

  before
    let g:test#javascript#runner = 'buntest'
    cd spec/fixtures/bun
  end

  after
    call Teardown()
    cd -
  end

  context "on nearest tests"
    it "runs JavaScript"
      view +1 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'bun test -t ''Math'' __tests__/normal-test.js'

      view +2 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'bun test -t ''Math Addition'' __tests__/normal-test.js'

      view +3 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'bun test -t ''Math Addition adds two numbers'' __tests__/normal-test.js'
    end

    it "runs loop tests"
      view +1 __tests__/loop-test.js
      TestNearest

      Expect g:test#last_command == 'bun test -t ''Loop the test with given array'' __tests__/loop-test.js'

      view +2 __tests__/loop-test.js
      TestNearest

      Expect g:test#last_command == 'bun test -t ''loop each tests'' __tests__/loop-test.js'

      view +3 __tests__/loop-test.js
      TestNearest

      Expect g:test#last_command == 'bun test -t ''described loop test'' __tests__/loop-test.js'
    end

    it "aliases context to describe"
      view +1 __tests__/context-test.js
      TestNearest

      Expect g:test#last_command == 'bun test -t ''Math'' __tests__/context-test.js'

      view +2 __tests__/context-test.js
      TestNearest

      Expect g:test#last_command == 'bun test -t ''Math Addition'' __tests__/context-test.js'

      view +3 __tests__/context-test.js
      TestNearest

      Expect g:test#last_command == 'bun test -t ''Math Addition adds two numbers'' __tests__/context-test.js'

      view +2 __tests__/escaping-test.js
      TestNearest

      Expect g:test#last_command == 'bun test -t ''Escaping parentheses \\('' __tests__/escaping-test.js'

      view +5 __tests__/escaping-test.js
      TestNearest

      Expect g:test#last_command == 'bun test -t ''Escaping brackets \\['' __tests__/escaping-test.js'
    end

  it "runs file test if nearest test couldn't be found"
    view +1 __tests__/normal-test.js
    normal O
    TestNearest

    Expect g:test#last_command == 'bun test __tests__/normal-test.js'
  end

  it "runs file tests"
    view +1 __tests__/normal-test.js
    TestFile

    Expect g:test#last_command == 'bun test __tests__/normal-test.js'

    view +2 __tests__/(folder)/normal-test.js
    TestFile

    Expect g:test#last_command == 'bun test __tests__/\(folder\)/normal-test.js'
  end

  it "runs test suites"
    view __tests__/normal-test.js
    TestSuite

    Expect g:test#last_command == 'bun test'
  end

  it "runs tests outside of __tests__"
    view outside-test.js
    TestFile

    Expect g:test#last_command == 'bun test outside-test.js'
  end
end

