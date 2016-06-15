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
    SKIP "Disabled until functionality is implemented"
    view +2 spec/normal_spec.js
    TestNearest

    Expect g:test#last_command == 'karma start --single-run -- spec/normal_spec.js --filter=''Addition adds two numbers'''
  end

  it "runs file tests"
    SKIP "Disabled until functionality is implemented"
    view spec/normal_spec.js
    TestFile

    Expect g:test#last_command == 'karma start --single-run -- spec/normal_spec.js'
  end

  it "runs test suites"
    view spec/normal_spec.js
    TestSuite

    Expect g:test#last_command == 'karma start --single-run'
  end

  it "is case insensitive about the filename"
    SKIP "Disabled until functionality is implemented"
    view spec/normalSpec.js
    TestFile

    Expect g:test#last_command == 'karma start --single-run -- spec/normalSpec.js'
  end

  it "doesn't recognize files that don't end with 'spec'"
    view spec/normal.js
    TestFile

    Expect exists('g:test#last_command') == 0
  end

  it "runs CoffeeScript"
    SKIP "Disabled until functionality is implemented"
    view spec/normal_spec.coffee
    TestFile

    Expect g:test#last_command == 'karma start --single-run -- spec/normal_spec.coffee'
  end

  it "runs React"
    SKIP "Disabled until functionality is implemented"
    view spec/normal_spec.jsx
    TestFile

    Expect g:test#last_command == 'karma start --single-run -- spec/normal_spec.jsx'
  end

end
