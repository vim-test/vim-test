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

  it "detects CoffeeScript"
    try
      edit spec/normal_spec.coffee | write
      TestFile

      Expect g:test#last_command == 'jasmine-node --coffee spec/normal_spec.coffee'

      Jasmine .

      Expect g:test#last_command == 'jasmine-node --coffee .'
    finally
      !rm spec/normal_spec.coffee
    endtry
  end

end
