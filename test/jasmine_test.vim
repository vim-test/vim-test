source test/helpers.vim

describe "Jasmine"

  before
    cd test/fixtures/jasmine
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests instead of nearest tests"
    view +1 normal_spec.js
    TestNearest

    Expect g:test#last_command == 'jasmine-node normal_spec.js'
  end

  it "runs file tests"
    view normal_spec.js
    TestFile

    Expect g:test#last_command == 'jasmine-node normal_spec.js'
  end

  it "runs test suites"
    view normal_spec.js
    TestSuite

    Expect g:test#last_command == 'jasmine-node spec/'
  end

  it "is case insensitive about the filename"
    view normalSpec.js
    TestFile

    Expect g:test#last_command == 'jasmine-node normalSpec.js'
  end

  it "doesn't recognize files that don't end with 'spec'"
    view normal.js
    TestFile

    Expect exists('g:test#last_command') == 0
  end

  it "detects CoffeeScript"
    try
      edit normal_spec.coffee | write
      TestFile

      Expect g:test#last_command == 'jasmine-node --coffee normal_spec.coffee'

      Jasmine .

      Expect g:test#last_command == 'jasmine-node --coffee .'
    finally
      !rm normal_spec.coffee
    endtry
  end

end
