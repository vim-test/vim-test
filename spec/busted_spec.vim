source spec/helpers.vim

describe "GoTest"

  before
    cd spec/fixtures/busted
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests instead of nearest tests"
    view normal_spec.lua
    TestNearest

    Expect LastCommand() == 'busted normal_spec.lua'
  end

  it "runs file tests"
    view normal_spec.lua
    TestFile

    Expect LastCommand() == 'busted normal_spec.lua'
  end

  it "runs test suites"
    view normal_spec.lua
    TestSuite

    Expect LastCommand() == 'busted'
  end

end

