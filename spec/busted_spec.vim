source spec/support/helpers.vim

describe "LuaTest"

  before
    cd spec/fixtures/busted
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view normal_spec.lua
    TestNearest

    Expect g:test#last_command == 'busted --filter ''Numbers'' normal_spec.lua'
    # TODO: describe
    # TODO: it
    # TODO: magic characters
    # TODO: moon
  end

  it "runs file tests"
    view normal_spec.lua
    TestFile

    Expect g:test#last_command == 'busted normal_spec.lua'

    view normal_spec.moon
    TestFile

    Expect g:test#last_command == 'busted normal_spec.moon'
  end

  it "runs test suites"
    view normal_spec.lua
    TestSuite

    Expect g:test#last_command == 'busted'
  end

end

