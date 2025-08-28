source spec/support/helpers.vim

let g:expectedExecutable = ''

describe "vitest"

  before
    cd spec/fixtures/vitest
    if executable('npx')
        let g:expectedExecutable = 'npx '
    endif
  end

  after
    call Teardown()
    cd -
    unlet g:expectedExecutable
  end

  context "on nearest tests"
    it "runs JSX"
      view +1 __tests__/normal-test.jsx
      TestNearest

      Expect g:test#last_command == g:expectedExecutable .. 'vitest run -t ''Math'' __tests__/normal-test.jsx'

      view +2 __tests__/normal-test.jsx
      TestNearest

      Expect g:test#last_command == g:expectedExecutable .. 'vitest run -t ''Math Addition'' __tests__/normal-test.jsx'

      view +3 __tests__/normal-test.jsx
      TestNearest

      Expect g:test#last_command == g:expectedExecutable .. 'vitest run -t ''Math Addition adds two numbers'' __tests__/normal-test.jsx'

      view +2 __tests__/escaping-test.ts
      TestNearest

      Expect g:test#last_command == g:expectedExecutable .. 'vitest run -t ''Escaping parentheses \\('' __tests__/escaping-test.ts'

      view +5 __tests__/escaping-test.ts
      TestNearest

      Expect g:test#last_command == g:expectedExecutable .. 'vitest run -t ''Escaping brackets \\['' __tests__/escaping-test.ts'
    end

    it "runs loop tests"
      view +1 __tests__/loop-test.jsx
      TestNearest

      Expect g:test#last_command == g:expectedExecutable .. 'vitest run -t ''Loop the test with given array'' __tests__/loop-test.jsx'

      view +2 __tests__/loop-test.jsx
      TestNearest

      Expect g:test#last_command == g:expectedExecutable .. 'vitest run -t ''loop each tests'' __tests__/loop-test.jsx'

      view +3 __tests__/loop-test.jsx
      TestNearest

      Expect g:test#last_command == g:expectedExecutable .. 'vitest run -t ''described loop test'' __tests__/loop-test.jsx'
    end

    it "aliases context to describe"
      view +1 __tests__/context-test.jsx
      TestNearest

      Expect g:test#last_command == g:expectedExecutable .. 'vitest run -t ''Math'' __tests__/context-test.jsx'

      view +2 __tests__/context-test.jsx
      TestNearest

      Expect g:test#last_command == g:expectedExecutable .. 'vitest run -t ''Math Addition'' __tests__/context-test.jsx'

      view +3 __tests__/context-test.jsx
      TestNearest

      Expect g:test#last_command == g:expectedExecutable .. 'vitest run -t ''Math Addition adds two numbers'' __tests__/context-test.jsx'
    end

    it "runs TypescriptReact"
      view +1 __tests__/normal-test.tsx
      TestNearest

      Expect g:test#last_command == g:expectedExecutable .. 'vitest run -t ''Math'' __tests__/normal-test.tsx'

      view +2 __tests__/normal-test.tsx
      TestNearest

      Expect g:test#last_command == g:expectedExecutable .. 'vitest run -t ''Math Addition'' __tests__/normal-test.tsx'

      view +3 __tests__/normal-test.tsx
      TestNearest

      Expect g:test#last_command == g:expectedExecutable .. 'vitest run -t ''Math Addition adds two numbers'' __tests__/normal-test.tsx'
    end
  end

  it "runs file test if nearest test couldn't be found"
    view +1 __tests__/normal-test.jsx
    normal O
    TestNearest

    Expect g:test#last_command == g:expectedExecutable .. 'vitest run __tests__/normal-test.jsx'
  end

  it "runs file tests"
    view __tests__/normal-test.jsx
    TestFile

    Expect g:test#last_command == g:expectedExecutable .. 'vitest run __tests__/normal-test.jsx'
  end

  it "runs test suites"
    view __tests__/normal-test.jsx
    TestSuite

    Expect g:test#last_command == g:expectedExecutable .. 'vitest run'
  end

  it "runs tests outside of __tests__"
    view outside-test.jsx
    TestFile

    Expect g:test#last_command == g:expectedExecutable .. 'vitest run outside-test.jsx'
  end

  context "with a specified executable"
    after
      unlet g:test#javascript#vitest#executable
    end

    it "runs tests against npm executable"
      let g:test#javascript#vitest#executable = 'npm run vitest'
      view __tests__/normal-test.jsx
      TestFile

      Expect g:test#last_command == 'npm run vitest run __tests__/normal-test.jsx'
    end

    it "runs tests against yarn executable (without --)"
      let g:test#javascript#vitest#executable = 'yarn vitest'
      view __tests__/normal-test.jsx
      TestFile

      Expect g:test#last_command == 'yarn vitest run __tests__/normal-test.jsx'
    end

    it "runs tests against absolute path yarn executable (without --)"
      let g:test#javascript#vitest#executable = '~/.local/bin/yarn vitest'
      view __tests__/normal-test.jsx
      TestFile

      Expect g:test#last_command == '~/.local/bin/yarn vitest run __tests__/normal-test.jsx'
    end
  end

end
