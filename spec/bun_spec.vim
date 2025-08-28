source spec/support/helpers.vim

describe "BunTest"

  before
    cd spec/fixtures/bun
  end

  after
    call Teardown()
    cd -
  end

  context "on nearest tests"
    it "runs JavaScript"
      view +3 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'bun test -t ''Math'' __tests__/normal-test.js'

      view +4 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'bun test -t ''Math Addition'' __tests__/normal-test.js'

      view +5 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'bun test -t ''Math Addition adds two numbers'' __tests__/normal-test.js'
    end

  it "runs file test if nearest test couldn't be found"
    view +3 __tests__/normal-test.js
    normal O
    TestNearest

    Expect g:test#last_command == 'bun test __tests__/normal-test.js'
  end

  it "runs file tests"
    view +1 __tests__/normal-test.js
    TestFile

    Expect g:test#last_command == 'bun test __tests__/normal-test.js'
  end

  it "runs test suites"
    view __tests__/normal-test.js
    TestSuite

    Expect g:test#last_command == 'bun test'
  end
end

