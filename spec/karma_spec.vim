source spec/support/helpers.vim

describe "Karma"

  before
    cd spec/fixtures/karma
    let g:karma_runner = 'node_modules/karma-cli-runner/karma-args'
  end

  after
    call Teardown()
    unlet g:karma_runner
    cd -
  end

  it "runs nearest tests"
    view +2 normal_spec.js
    TestNearest

    Expect g:test#last_command == 'node ' . g:karma_runner . ' --files normal_spec.js --filter ''Addition adds two numbers'' --single-run --no-auto-watch --log-level=disable'
  end

  it "runs file tests"
    view normal_spec.js
    TestFile

    Expect g:test#last_command == 'node ' . g:karma_runner . ' --files normal_spec.js --single-run --no-auto-watch --log-level=disable'
  end

  it "runs test suites"
    view spec/normal_spec.js
    TestSuite

    Expect g:test#last_command == 'node ' . g:karma_runner . ' --single-run --no-auto-watch --log-level=disable'
  end

  it "is case insensitive about the filename"
    view normalSpec.js
    TestFile

    Expect g:test#last_command == 'node ' . g:karma_runner . ' --files normalSpec.js --single-run --no-auto-watch --log-level=disable'
  end

  it "detects tests in files ending with 'test'"
    view normal_test.js
    TestSuite

    Expect g:test#last_command == 'node ' . g:karma_runner . ' --single-run --no-auto-watch --log-level=disable'
  end

  it "runs CoffeeScript"
    view spec/normal_spec.coffee
    TestSuite

    Expect g:test#last_command == 'node ' . g:karma_runner . ' --single-run --no-auto-watch --log-level=disable'
  end

  it "runs React"
    view spec/normal_spec.jsx
    TestSuite

    Expect g:test#last_command == 'node ' . g:karma_runner . ' --single-run --no-auto-watch --log-level=disable'
  end

  it "doesn't recognize files that don't end with 'spec' or 'test'"
    view normal.js
    TestFile

    Expect exists('g:test#last_command') == 0
  end
end
