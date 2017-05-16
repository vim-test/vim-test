source spec/support/helpers.vim

describe "Lab"

  before
    cd spec/fixtures/lab
  end

  after
    call Teardown()
    cd -
  end

  context "on nearest tests"
    it "runs JavaScript"
      view +6 test/normal.js
      TestNearest

      Expect g:test#last_command == 'lab test/normal.js --grep ''^Math'''

      view +7 test/normal.js
      TestNearest

      Expect g:test#last_command == 'lab test/normal.js --grep ''^Math Addition'''

      view +8 test/normal.js
      TestNearest

      Expect g:test#last_command == 'lab test/normal.js --grep ''^Math Addition adds two numbers$'''
    end
  end

  it "runs file test if nearest test couldn't be found"
    view +6 test/normal.js
    normal O
    TestNearest

    Expect g:test#last_command == 'lab test/normal.js'
  end

  it "runs file tests"
    view test/normal.js
    TestFile

    Expect g:test#last_command == 'lab test/normal.js'
  end

  it "runs test suites"
    view test/normal.js
    TestSuite

    Expect g:test#last_command == 'lab'
  end

  it "doesn't detect JavaScripts which are not in the test/ folder"
    view outside.js
    TestSuite

    Expect exists('g:test#last_command') == 0
  end

end
