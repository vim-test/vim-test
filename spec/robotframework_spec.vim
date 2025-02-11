source spec/support/helpers.vim

describe "robotframework"

  before
    let g:test#robotframework#runner = 'robotframework'
    cd spec/fixtures/robotframework
  end

  after
    unlet g:test#robotframework#runner
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +7 test.robot
    TestNearest

    Expect g:test#last_command == 'python3 -m robot --test "Normal Test" test.robot
  end

  it "runs nearest tests later line"
    view +15 test.robot
    TestNearest

    Expect g:test#last_command == 'python3 -m robot --test "Normal Test 2" test.robot
  end

  it "runs file tests"
    view test.robot
    TestFile

    Expect g:test#last_command == 'python3 -m robot test.robot'
  end
end
