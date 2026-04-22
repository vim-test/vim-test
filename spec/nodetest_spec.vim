source spec/support/helpers.vim

describe "Node Test"

  before
    cd spec/fixtures/nodetest
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests"
    view normal.test.js
    TestFile

    Expect g:test#last_command == 'node --test normal.test.js'
  end

  it "runs TypeScript file tests"
    view normal.test.ts
    TestFile

    Expect g:test#last_command == 'node --test normal.test.ts'
  end

  it "runs file tests with multiline imports"
    view multiline-import.test.js
    TestFile

    Expect g:test#last_command == 'node --test multiline-import.test.js'
  end

  it "runs file tests with multiline imports across multiple names"
    view multiline-multiple-imports.test.js
    TestFile

    Expect g:test#last_command == 'node --test multiline-multiple-imports.test.js'
  end

  it "runs file tests with CommonJS require"
    view commonjs-require.test.js
    TestFile

    Expect g:test#last_command == 'node --test commonjs-require.test.js'
  end

  it "runs file tests with CommonJS require spacing"
    view spaced-commonjs-require.test.js
    TestFile

    Expect g:test#last_command == 'node --test spaced-commonjs-require.test.js'
  end

  it "does not treat from(...) calls as imports"
    Expect test#javascript#has_import('false-positive.test.js', 'node:test') == 0
  end
end
