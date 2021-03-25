source spec/support/helpers.vim

describe "PubRunTest"

  before
    cd spec/fixtures/pubruntest
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests"
    view basic_test.dart
    TestFile
    Expect g:test#last_command == 'pub run test basic_test.dart'
  end

  it "runs nearest tests"
    view +6 basic_test.dart
    TestNearest

    Expect g:test#last_command == 'pub run test --plain-name "no group test" basic_test.dart'

    view +26 basic_test.dart
    TestNearest

    Expect g:test#last_command == 'pub run test --plain-name "Counter value should be decremented" basic_test.dart'
  end

  it "runs test suites"
    view basic_test.dart
    TestSuite

    Expect g:test#last_command == 'pub run test'
  end

end

