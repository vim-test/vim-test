source spec/support/helpers.vim

describe "Karma"

  before
    cd spec/fixtures/karma
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    let arg_file = 'node_modules/karma-cli-runner/karma-args'
    view +2 normal_spec.js
    TestNearest

    Expect g:test#last_command == 'node ' . arg_file . ' --files normal_spec.js --filter ''Addition adds two numbers'''
  end

  it "runs file tests"
    let arg_file = 'node_modules/karma-cli-runner/karma-args'
    view normal_spec.js
    TestFile

    Expect g:test#last_command == 'node ' . arg_file . ' --files normal_spec.js'
  end

  it "runs test suites"
    let arg_file = 'node_modules/karma-cli-runner/karma-args'
    view spec/normal_spec.js
    TestSuite

    Expect g:test#last_command == 'node ' . arg_file
  end

  it "is case insensitive about the filename"
    let arg_file = 'node_modules/karma-cli-runner/karma-args'
    view normalSpec.js
    TestFile

    Expect g:test#last_command == 'node ' . arg_file . ' --files normalSpec.js'
  end

  it "detects tests in files ending with 'test'"
    let arg_file = 'node_modules/karma-cli-runner/karma-args'
    view normal_test.js
    TestSuite

    Expect g:test#last_command == 'node ' . arg_file
  end

  it "runs CoffeeScript"
    let arg_file = 'node_modules/karma-cli-runner/karma-args'
    view spec/normal_spec.coffee
    TestSuite

    Expect g:test#last_command == 'node ' . arg_file
  end

  it "runs React"
    let arg_file = 'node_modules/karma-cli-runner/karma-args'
    view spec/normal_spec.jsx
    TestSuite

    Expect g:test#last_command == 'node ' . arg_file
  end

  it "doesn't recognize files that don't end with 'spec' or 'test'"
    view normal.js
    TestFile

    Expect exists('g:test#last_command') == 0
  end
end
