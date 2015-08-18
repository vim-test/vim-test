source spec/helpers.vim

describe "Jasmine"

  before
    cd spec/fixtures/jasmine
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests instead of nearest tests"
    view +1 spec/normal_spec.js
    TestNearest

    Expect g:test#last_command == 'jasmine-node spec/normal_spec.js'
  end

  it "runs file tests"
    view spec/normal_spec.js
    TestFile

    Expect g:test#last_command == 'jasmine-node spec/normal_spec.js'
  end

  it "runs test suites"
    view spec/normal_spec.js
    TestSuite

    Expect g:test#last_command == 'jasmine-node spec/'
  end

  it "is case insensitive about the filename"
    view spec/normalSpec.js
    TestFile

    Expect g:test#last_command == 'jasmine-node spec/normalSpec.js'
  end

  it "doesn't recognize files that don't end with 'spec'"
    view spec/normal.js
    TestFile

    Expect exists('g:test#last_command') == 0
  end

  it "runs CoffeeScript"
    view spec/normal_spec.coffee
    TestFile

    Expect g:test#last_command == 'jasmine-node spec/normal_spec.coffee'
  end

  it "runs React"
    view spec/normal_spec.jsx
    TestFile

    Expect g:test#last_command == 'jasmine-node spec/normal_spec.jsx'
  end

end
