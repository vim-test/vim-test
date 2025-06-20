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
end
