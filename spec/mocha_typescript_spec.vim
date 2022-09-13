source spec/support/helpers.vim

describe "Mocha typescript"

  before
    cd spec/fixtures/mocha-typescript
  end

  after
    call Teardown()
    cd -
  end

  context "on nearest tests"

    it "runs typescript"
      view +1 test/normal.ts
      TestNearest

      Expect g:test#last_command == 'mocha -r ts-node/register test/normal.ts --grep ''^Math'''

      view +2 test/normal.ts
      TestNearest

      Expect g:test#last_command == 'mocha -r ts-node/register test/normal.ts --grep ''^Math Addition'''

      view +3 test/normal.ts
      TestNearest

      Expect g:test#last_command == 'mocha -r ts-node/register test/normal.ts --grep ''^Math Addition adds two numbers$'''
    end

    it "runs typescript JSX"
      view +1 test/normal.tsx
      TestNearest

      Expect g:test#last_command == 'mocha -r ts-node/register test/normal.tsx --grep ''^Math'''

      view +2 test/normal.tsx
      TestNearest

      Expect g:test#last_command == 'mocha -r ts-node/register test/normal.tsx --grep ''^Math Addition'''

      view +3 test/normal.tsx
      TestNearest

      Expect g:test#last_command == 'mocha -r ts-node/register test/normal.tsx --grep ''^Math Addition adds two numbers$'''
    end
  end

  it "runs file test if nearest test couldn't be found"
    view +1 test/normal.ts
    normal O
    TestNearest

    Expect g:test#last_command == 'mocha -r ts-node/register test/normal.ts'
  end

  it "runs file tests"
    view test/normal.ts
    TestFile

    Expect g:test#last_command == 'mocha -r ts-node/register test/normal.ts'
  end

  it "runs test suites"
    view test/normal.ts
    TestSuite

    Expect g:test#last_command == 'mocha -r ts-node/register --recursive test/ --extension ts'
  end

  it "also recognizes tests/ directory"
    try
      !mv test tests
      view tests/normal.ts
      TestFile

      Expect g:test#last_command == 'mocha -r ts-node/register tests/normal.ts'
    finally
      !mv tests test
    endtry
  end

  it "can handle test file when outside test directory"
    view src/addition.test.ts
    TestFile

    Expect g:test#last_command == 'mocha -r ts-node/register src/addition.test.ts'
  end

  it "uses a glob path for test suite when not using the standard test directory"
    view src/addition.test.ts
    TestSuite

    Expect g:test#last_command == 'mocha -r ts-node/register "src/**/*.test.ts"'
  end
end
