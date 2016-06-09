source spec/support/helpers.vim

describe "TAP"

  before
    cd spec/fixtures/tap
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests instead of nearest test"
    view +6 tests/normal.js
    TestNearest

    Expect g:test#last_command == 'node_modules/.bin/tape tests/normal.js'
  end

  it "runs file tests"
    view tests/normal.js
    TestFile

    Expect g:test#last_command == 'node_modules/.bin/tape tests/normal.js'
  end

  it "runs test suites"
    view tests/normal.js
    TestSuite

    Expect g:test#last_command == 'node_modules/.bin/tape "tests/**/*.js"'
  end

  it "also recognizes test/ directory"
    view test/normal.js
    TestFile

    Expect g:test#last_command == 'node_modules/.bin/tape test/normal.js'
  end

  it "it uses the specified reporter if it exists"
    view tests/normal.js
    let g:test#javascript#tap#reporters = ['tap-spec']
    TestFile

      Expect g:test#last_command == 'node_modules/.bin/tape tests/normal.js | node_modules/.bin/tap-spec'
  end

  it "it doesn't use the specified reporter if it doesn't exist"
    view tests/normal.js
    let g:test#javascript#tap#reporters = ['tap-min']
    TestFile

      Expect g:test#last_command == 'node_modules/.bin/tape tests/normal.js'
  end

  it "it uses multiple specified reporters if they exists"
    view tests/normal.js
    let g:test#javascript#tap#reporters = ['tap-notify', 'tap-spec']
    TestFile

      Expect g:test#last_command == 'node_modules/.bin/tape tests/normal.js | node_modules/.bin/tap-notify | node_modules/.bin/tap-spec'
  end

end
