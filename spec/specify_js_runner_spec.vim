source spec/support/helpers.vim

let s:repo_dir = getcwd()
let s:fixture_dir = s:repo_dir . '/spec/fixtures/js_multiple'

describe "Multiple JavaScript runners"

  before
    execute 'cd ' . fnameescape(s:fixture_dir)
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

  it "detects packages from parent directories"
    cd __tests__

    Expect test#javascript#has_package('mocha') == 1
    Expect test#javascript#has_package('definitely-not-a-real-package') == 0

    execute 'cd ' . fnameescape(s:fixture_dir)
  end

  after
    call Teardown()
    execute 'cd ' . fnameescape(s:repo_dir)
  end

end
