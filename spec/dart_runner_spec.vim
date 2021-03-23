source spec/support/helpers.vim

describe "Dart Runner"
  before
    cd spec/fixtures
  end

  after
    cd -
  end

  describe "when test#dart#runner is not set"
    after
      call Teardown()
    end
    it "should use flutter test if 'package:flutter_test/flutter_test.dart' is found"
      view fluttertest/widgets_test.dart
      TestFile
      Expect g:test#last_command =~# '\v^flutter test'
    end
    it "should use pub run test otherwise"
      view pubruntest/basic_test.dart
      TestFile
      Expect g:test#last_command =~# '\v^pub run test'
    end
  end

  describe "when test#dart#runner is set"
    it "should respect test#dart#runner"
      for runner in ["fluttertest", "pubruntest"]
        let g:test#dart#runner = runner
        Expect test#determine_runner("pubruntest/basic_test.dart") == 'dart#'.runner
        Expect test#determine_runner("fluttertest/widgets_test.dart") == 'dart#'.runner
      endfor
    end
  end
