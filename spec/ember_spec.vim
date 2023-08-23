source spec/support/helpers.vim

describe "Ember"
  before
    cd spec/fixtures/ember
  end

  after
    call Teardown()
    cd -
  end

  context "on nearest tests"
    it "runs JavaScript"
      view +1 test/normal-test.js
      TestNearest

      Expect g:test#last_command == "ember exam --module 'Math'"

      view +2 test/normal-test.js
      TestNearest

      Expect g:test#last_command == "ember exam --module 'Math > Addition'"

      view +3 test/normal-test.js
      TestNearest

      Expect g:test#last_command == "ember exam --filter 'adds two numbers' --module 'Math > Addition'"
    end

    it "supports quotes in test descriptions"
      view +1 test/quotes-test.js
      TestNearest

      Expect g:test#last_command == "ember exam --module '\"Math\"'"

      view +2 test/quotes-test.js
      TestNearest

      Expect g:test#last_command == "ember exam --filter 'adds 2 (\"two\") numbers' --module '\"Math\"'"
    end

    it "runs CoffeeScript"
      view +1 test/normal-test.coffee
      TestNearest

      Expect g:test#last_command == "ember exam --module 'Math'"

      view +2 test/normal-test.coffee
      TestNearest

      Expect g:test#last_command == "ember exam --module 'Math > Addition'"

      view +3 test/normal-test.coffee
      TestNearest

      Expect g:test#last_command == "ember exam --filter 'adds two numbers' --module 'Math > Addition'"
    end

    it "runs typescript"
      view +2 test/normal-test.ts
      TestNearest

      Expect g:test#last_command == "ember exam --module 'Math'"

      view +3 test/normal-test.ts
      TestNearest

      Expect g:test#last_command == "ember exam --module 'Math > Addition'"

      view +4 test/normal-test.ts
      TestNearest

      Expect g:test#last_command == "ember exam --filter 'adds two numbers' --module 'Math > Addition'"
    end

    it "runs JSX"
      view +1 test/normal-test.jsx
      TestNearest

      Expect g:test#last_command == "ember exam --module 'Math'"

      view +2 test/normal-test.jsx
      TestNearest

      Expect g:test#last_command == "ember exam --module 'Math > Addition'"

      view +3 test/normal-test.jsx
      TestNearest

      Expect g:test#last_command == "ember exam --filter 'adds two numbers' --module 'Math > Addition'"
    end

    it "runs typescript JSX"
      view +2 test/normal-test.tsx
      TestNearest

      Expect g:test#last_command == "ember exam --module 'Math'"

      view +3 test/normal-test.tsx
      TestNearest

      Expect g:test#last_command == "ember exam --module 'Math > Addition'"

      view +4 test/normal-test.tsx
      TestNearest

      Expect g:test#last_command == "ember exam --filter 'adds two numbers' --module 'Math > Addition'"
    end
  end

  it "runs file if nearest test couldn't be found"
    view +1 test/normal-test.js
    normal O
    TestNearest

    Expect g:test#last_command == "ember exam --module 'Math'"
  end

  it "runs file tests"
    view test/normal-test.js
    TestFile

    Expect g:test#last_command == "ember exam --module 'Math'"
  end

  it "runs test suites"
    view test/normal-test.js
    TestSuite

    Expect g:test#last_command == 'ember exam'
  end

  it "can handle test file when outside test directory"
    view src/addition-test.js
    TestFile

    Expect g:test#last_command == "ember exam --module 'Addition'"
  end
end
