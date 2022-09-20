source spec/support/helpers.vim

describe "Nim"

  before
    cd spec/fixtures/nim
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +5 test_normal.nim
    TestNearest

    Expect g:test#last_command == "nim compile --run test_normal.nim 'add minutes'"
  end

  it "runs file tests"
    view test_normal.nim
    TestFile

    Expect g:test#last_command == 'nim compile --run test_normal.nim'
  end

  it "runs test suites"
    view +4 test_normal.nim
    TestSuite

    Expect g:test#last_command == "nim compile --run test_normal.nim 'Clock addition::'"
  end
end
