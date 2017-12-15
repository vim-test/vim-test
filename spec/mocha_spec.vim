source spec/support/helpers.vim

describe "Mocha"

  before
    cd spec/fixtures/mocha
  end

  after
    call Teardown()
    cd -
  end

  context "on nearest tests"
    it "runs JavaScript"
      view +1 test/normal.js
      TestNearest

      Expect g:test#last_command == 'mocha test/normal.js --grep ''^Math'''

      view +2 test/normal.js
      TestNearest

      Expect g:test#last_command == 'mocha test/normal.js --grep ''^Math Addition'''

      view +3 test/normal.js
      TestNearest

      Expect g:test#last_command == 'mocha test/normal.js --grep ''^Math Addition adds two numbers$'''
    end

    it "aliases context to describe"
      view +1 test/context.js
      TestNearest

      Expect g:test#last_command == 'mocha test/context.js --grep ''^Math'''

      view +2 test/context.js
      TestNearest

      Expect g:test#last_command == 'mocha test/context.js --grep ''^Math Addition'''

      view +3 test/context.js
      TestNearest

      Expect g:test#last_command == 'mocha test/context.js --grep ''^Math Addition adds two numbers$'''
    end

    it "runs CoffeeScript"
      view +1 test/normal.coffee
      TestNearest

      Expect g:test#last_command == 'mocha test/normal.coffee --grep ''^Math'''

      view +2 test/normal.coffee
      TestNearest

      Expect g:test#last_command == 'mocha test/normal.coffee --grep ''^Math Addition'''

      view +3 test/normal.coffee
      TestNearest

      Expect g:test#last_command == 'mocha test/normal.coffee --grep ''^Math Addition adds two numbers$'''
    end

    it "runs React"
      view +1 test/normal.jsx
      TestNearest

      Expect g:test#last_command == 'mocha test/normal.jsx --grep ''^Math'''

      view +2 test/normal.jsx
      TestNearest

      Expect g:test#last_command == 'mocha test/normal.jsx --grep ''^Math Addition'''

      view +3 test/normal.jsx
      TestNearest

      Expect g:test#last_command == 'mocha test/normal.jsx --grep ''^Math Addition adds two numbers$'''
    end
  end

  it "runs file test if nearest test couldn't be found"
    view +1 test/normal.js
    normal O
    TestNearest

    Expect g:test#last_command == 'mocha test/normal.js'
  end

  it "runs file tests"
    view test/normal.js
    TestFile

    Expect g:test#last_command == 'mocha test/normal.js'
  end

  it "runs test suites"
    view test/normal.js
    TestSuite

    Expect g:test#last_command == 'mocha --recursive test/'
  end

  it "also recognizes tests/ directory"
    try
      !mv test tests
      view tests/normal.js
      TestFile

      Expect g:test#last_command == 'mocha tests/normal.js'
    finally
      !mv tests test
    endtry
  end

  it "doesn't detect JavaScripts which are not in the test/ folder"
    view outside.js
    TestSuite

    Expect exists('g:test#last_command') == 0
  end

end
