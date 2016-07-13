source spec/support/helpers.vim

describe "Karma"

  before
    cd spec/fixtures/jasmine
		let g:test#javascript#jasmine#file_pattern = '^none.js$'
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    let arg_file = expand('<sfile>:p:h:h:h:h') . '/autoload/test/javascript/karma-args'
    view +2 spec/normal_spec.js
    TestNearest

    Expect g:test#last_command == 'node ' . arg_file . ' spec/normal_spec.js --filter=''Addition adds two numbers'''
  end

  it "runs file tests"
    let arg_file = expand('<sfile>:p:h:h:h:h') . '/autoload/test/javascript/karma-args'
    view spec/normal_spec.js
    TestFile

    Expect g:test#last_command == 'node ' . arg_file . ' spec/normal_spec.js'
  end

  it "runs test suites"
    let arg_file = expand('<sfile>:p:h:h:h:h') . '/autoload/test/javascript/karma-args'
    view spec/normal_spec.js
    TestSuite

    Expect g:test#last_command == 'node ' . arg_file
  end

  it "is case insensitive about the filename"
    let arg_file = expand('<sfile>:p:h:h:h:h') . '/autoload/test/javascript/karma-args'
    view spec/normalSpec.js
    TestFile

    Expect g:test#last_command == 'node ' . arg_file . ' spec/normalSpec.js'
  end

  it "doesn't recognize files that don't end with 'spec'"
    view spec/normal.js
    TestFile

    Expect exists('g:test#last_command') == 0
  end

  it "runs CoffeeScript"
    let arg_file = expand('<sfile>:p:h:h:h:h') . '/autoload/test/javascript/karma-args'
    view spec/normal_spec.coffee
    TestFile

    Expect g:test#last_command == 'node ' . arg_file . ' spec/normal_spec.coffee'
  end

  it "runs React"
    let arg_file = expand('<sfile>:p:h:h:h:h') . '/autoload/test/javascript/karma-args'
    view spec/normal_spec.jsx
    TestFile

    Expect g:test#last_command == 'node ' . arg_file . ' spec/normal_spec.jsx'
  end

end
