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

  it "runs test file with options"
    let g:test#javascript#denotest#options = '--quiet'
    view test.js
    TestFile
    unlet g:test#javascript#denotest#options

    Expect g:test#last_command == 'deno test --quiet test.js'
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

  it "runs simple test nearest"
    view +5 nearest_test.ts
    TestNearest

    Expect g:test#last_command == "deno test --filter '/^Simple nearest$/' nearest_test.ts"
  end

  it "runs Deno module test nearest"
    view +10 nearest_test.ts
    TestNearest

    Expect g:test#last_command == "deno test --filter '/^Deno module nearest$/' nearest_test.ts"
  end

  it "runs name key test nearest"
    view +16 nearest_test.ts
    TestNearest

    Expect g:test#last_command == "deno test --filter '/^name key test nearest$/' nearest_test.ts"
  end

  it "runs one line name key test nearest"
    view +28 nearest_test.ts
    TestNearest

    Expect g:test#last_command == "deno test --filter '/^one line name key test nearest$/' nearest_test.ts"
  end
end
