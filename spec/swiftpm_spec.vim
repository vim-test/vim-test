source spec/support/helpers.vim

describe "SwiftPM"

  before
    cd spec/fixtures/swiftpm/
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +6 Tests/VimTestTests/VimTestTests.swift
    TestNearest
    Expect g:test#last_command == 'swift test --specifier VimTestTests.VimTestTests/testExample'

    view +10 Tests/VimTestTests/VimTestTests.swift
    TestNearest
    Expect g:test#last_command == 'swift test --specifier VimTestTests.VimTestTests/testOther'
  end

  it "runs file tests"
    view Tests/VimTestTests/VimTestTests.swift
    TestFile

    Expect g:test#last_command == 'swift test --specifier VimTestTests.VimTestTests'
  end

  it "runs test suites"
    view Tests/VimTestTests/VimTestTests.swift
    TestSuite

    Expect g:test#last_command == 'swift test'
  end

end
