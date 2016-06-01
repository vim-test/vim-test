source spec/support/helpers.vim
runtime! plugin/vader.vim

describe "Vader"

  before
    cd spec/fixtures/vader
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +4 math.vader
    TestNearest

    Expect g:test#last_command == ':4,6call vader#run(0, "math.vader")'

    view +8 math.vader
    TestNearest

    Expect g:test#last_command == ':7,8call vader#run(0, "math.vader")'
  end

  it "runs file test when it cannot find the nearest test"
    view +2 math.vader
    TestNearest

    Expect g:test#last_command == ':call vader#run(0, "math.vader")'
  end

  it "runs file tests"
    view math.vader
    TestFile

    Expect g:test#last_command == ':call vader#run(0, "math.vader")'
  end

  it "runs test suite"
    view math.vader
    TestSuite

    Expect g:test#last_command == ':call vader#run(0, "**/*.vader")'
  end

end
