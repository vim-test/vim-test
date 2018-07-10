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
    Expect g:test#last_command == 'swift test --filter VimTestTests.VimTestTests/testExample'

    view +10 Tests/VimTestTests/VimTestTests.swift
    TestNearest
    Expect g:test#last_command == 'swift test --filter VimTestTests.VimTestTests/testOther'
  end

  it "runs file tests"
    view Tests/VimTestTests/VimTestTests.swift
    TestFile

    Expect g:test#last_command == 'swift test --filter VimTestTests.VimTestTests'
  end

  it "runs test suites"
    view Tests/VimTestTests/VimTestTests.swift
    TestSuite

    Expect g:test#last_command == 'swift test'
  end

  it "recognizes final test cases"
    view Tests/VimTestTests/VimTestFinalTests.swift
    TestFile

    Expect g:test#last_command == 'swift test --filter VimTestTests.VimTestFinalTests'
  end

  it "recognizes test cases in the root of the test directory"
    view Tests/VimTestRootTests.swift
    TestFile

    Expect g:test#last_command == 'swift test --filter VimTestRootTests.VimTestRootTests'
  end

end
