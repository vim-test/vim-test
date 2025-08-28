source spec/support/helpers.vim

describe "Multiple JavaScript runners"

  before
    cd spec/fixtures/js_multiple
  end

  it "if not be specified it will return first matched runner"
    view +1 __tests__/normal-test.js
    normal O
    TestNearest

    Expect g:test#last_command == 'mocha __tests__/normal-test.js'
  end

  it "can be specified when js has multiple runners"
    let g:test#javascript#runner = 'jest'
    view +1 __tests__/normal-test.js
    normal O
    TestNearest

    Expect g:test#last_command == 'jest --runTestsByPath -- __tests__/normal-test.js'
    unlet g:test#javascript#runner
  end

  after
    call Teardown()
    cd -
  end

end
