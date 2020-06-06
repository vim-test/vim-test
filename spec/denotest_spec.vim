source spec/support/helpers.vim

describe "Deno"

  before
    cd spec/fixtures/deno
  end

  after
    call Teardown()
    cd -
  end

  it "runs JavaScript test file"
    view test.js
    TestFile

    Expect g:test#last_command == 'deno test test.js'
  end

  it "runs TypeScript test file"
    view test.ts
    TestFile

    Expect g:test#last_command == 'deno test test.ts'
  end

  it "runs test suites"
    view test.js
    TestSuite

    Expect g:test#last_command == 'deno test'
  end

  it "ignores files that do not contain Deno.test"
    view hello.js
    TestFile

    Expect exists('g:test#last_command') == 0
  end

end
