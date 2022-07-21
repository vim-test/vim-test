source spec/support/helpers.vim

describe "FlutterTest"

  before
    cd spec/fixtures/fluttertest
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests"
    view widgets_test.dart
    TestFile
    Expect g:test#last_command == 'flutter test widgets_test.dart'
  end

  it "runs nearest tests"
    view +8 widgets_test.dart
    TestNearest

    Expect g:test#last_command == 'flutter test --plain-name ''MyWidget has a title and message'' widgets_test.dart'

    view +20 widgets_test.dart
    TestNearest

    Expect g:test#last_command == 'flutter test --plain-name "MyWidget doesn''t have description" widgets_test.dart'

    view +30 widgets_test.dart
    TestNearest

    Expect g:test#last_command == 'flutter test --plain-name ''MyWidget has very very very very very very very very very very very long description'' widgets_test.dart'

    view +50 widgets_test.dart
    TestNearest

    Expect g:test#last_command == 'flutter test --plain-name ''MyWidget test with string array and very very very very very very very very very very very long description'' widgets_test.dart'

    view +55 widgets_test.dart
    TestNearest

    Expect g:test#last_command == 'flutter test --plain-name ''MyWidget a "b"'' widgets_test.dart'

    view +65 widgets_test.dart
    TestNearest

    Expect g:test#last_command == 'flutter test --plain-name "MyWidget a ''b''" widgets_test.dart'
  end

  it "runs test suites"
    view widgets_test.dart
    TestSuite

    Expect g:test#last_command == 'flutter test'
  end

end

