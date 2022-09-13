source spec/support/helpers.vim

describe "DartTest"

  before
    cd spec/fixtures/darttest
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests"
    view basic_test.dart
    TestFile
    Expect g:test#last_command == 'dart test basic_test.dart'
  end

  it "runs nearest tests"
    view +6 basic_test.dart
    TestNearest

    Expect g:test#last_command == 'dart test --plain-name "no group test" basic_test.dart'

    view +26 basic_test.dart
    TestNearest

    Expect g:test#last_command == 'dart test --plain-name "Counter value should be decremented" basic_test.dart'
  end

  it "runs test suites"
    view basic_test.dart
    TestSuite

    Expect g:test#last_command == 'dart test'
  end

end

