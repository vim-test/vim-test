source spec/helpers.vim
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

    Expect LastCommand() == ':4,6call vader#run(0, "math.vader")'

    view +8 math.vader
    TestNearest

    Expect LastCommand() == ':7,8call vader#run(0, "math.vader")'
  end

  it "runs file test when it cannot find the nearest test"
    view +2 math.vader
    TestNearest

    Expect LastCommand() == ':call vader#run(0, "math.vader")'
  end

  it "runs file tests"
    view math.vader
    TestFile

    Expect LastCommand() == ':call vader#run(0, "math.vader")'
  end

  it "runs test suite"
    view math.vader
    TestSuite

    Expect LastCommand() == ':call vader#run(0, "**/*.vader")'
  end

end
