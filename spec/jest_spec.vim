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

      Expect g:test#last_command == 'jest __tests__/normal-test.js -t ''^Math'''

      view +2 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'jest __tests__/normal-test.js -t ''^Math Addition'''

      view +3 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'jest __tests__/normal-test.js -t ''^Math Addition adds two numbers$'''
    end

    it "aliases context to describe"
      view +1 __tests__/context-test.js
      TestNearest

      Expect g:test#last_command == 'jest __tests__/context-test.js -t ''^Math'''

      view +2 __tests__/context-test.js
      TestNearest

      Expect g:test#last_command == 'jest __tests__/context-test.js -t ''^Math Addition'''

      view +3 __tests__/context-test.js
      TestNearest

      Expect g:test#last_command == 'jest __tests__/context-test.js -t ''^Math Addition adds two numbers$'''
    end

    it "runs CoffeeScript"
      view +1 __tests__/normal-test.coffee
      TestNearest

      Expect g:test#last_command == 'jest __tests__/normal-test.coffee -t ''^Math'''

      view +2 __tests__/normal-test.coffee
      TestNearest

      Expect g:test#last_command == 'jest __tests__/normal-test.coffee -t ''^Math Addition'''

      view +3 __tests__/normal-test.coffee
      TestNearest

      Expect g:test#last_command == 'jest __tests__/normal-test.coffee -t ''^Math Addition adds two numbers$'''
    end

    it "runs React"
      view +1 __tests__/normal-test.jsx
      TestNearest

      Expect g:test#last_command == 'jest __tests__/normal-test.jsx -t ''^Math'''

      view +2 __tests__/normal-test.jsx
      TestNearest

      Expect g:test#last_command == 'jest __tests__/normal-test.jsx -t ''^Math Addition'''

      view +3 __tests__/normal-test.jsx
      TestNearest

      Expect g:test#last_command == 'jest __tests__/normal-test.jsx -t ''^Math Addition adds two numbers$'''
    end
  end

  it "runs file test if nearest test couldn't be found"
    view +1 __tests__/normal-test.js
    normal O
    TestNearest

    Expect g:test#last_command == 'jest __tests__/normal-test.js'
  end

  it "runs file tests"
    view __tests__/normal-test.js
    TestFile

    Expect g:test#last_command == 'jest __tests__/normal-test.js'
  end

  it "runs test suites"
    view __tests__/normal-test.js
    TestSuite

    Expect g:test#last_command == 'jest'
  end

  it "runs tests outside of __tests__"
    view outside-test.js
    TestFile

    Expect g:test#last_command == 'jest outside-test.js'
  end

end
