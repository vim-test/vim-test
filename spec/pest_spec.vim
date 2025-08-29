source spec/support/helpers.vim

describe "Pest"

  before
    cd spec/fixtures/pest
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests"
    view PestTest.php
    TestFile

    Expect g:test#last_command == 'pest --colors PestTest.php'
  end

  it "runs file tests on normal tests"
    view NormalTest.php
    TestFile

    Expect g:test#last_command == 'pest --colors NormalTest.php'
  end

  it "runs tests"
    view +1 PestTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors PestTest.php"

    view +4 PestTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'is a test case' PestTest.php"

    view +8 PestTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'with a different descriptor' PestTest.php"

    view +12 PestTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'bdd flavour' PestTest.php"
  end

  it "runs nearest tests on normal tests"
    view +1 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors NormalTest.php"

    view +14 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'should_add_two_numbers' NormalTest.php"

    view +22 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'should_subtract_two_numbers' NormalTest.php"

    view +40 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'should_add_to_expected_value' NormalTest.php"
  end

  it  "runs nearest test marked with @test annotation"
    view +40 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'should_add_to_expected_value' NormalTest.php"

    view +50 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'a_test_marked_with_test_annotation' NormalTest.php"
  end

  it  "runs nearest test containing an anonymous class"
    view +72 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'with_an_anonymous_class' NormalTest.php"

    view +85 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'a_test_maked_with_test_annotation_and_with_an_anonymous_class' NormalTest.php"
  end

  it "runs nearest tests on normal test"
    view +1 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors NormalTest.php"

    view +14 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'should_add_two_numbers' NormalTest.php"

    view +22 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'should_subtract_two_numbers' NormalTest.php"

    view +40 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'should_add_to_expected_value' NormalTest.php"
  end

  it "runs nearest test with a one line @test annotation"
    view +94 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'a_test_marked_with_test_annotation_on_one_line' NormalTest.php"
  end

  it "runs nearest test with a one line #[Test] attribute"
    view +100 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'aTestMarkedWithTestAttributeOnOneLine' NormalTest.php"
  end

  it "runs nearest test with a one line #[Test] attribute in a group"
    view +106 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'aTestMarkedWithTestAttributeInGroupOnOneLine' NormalTest.php"
  end

  it "runs test suites"
    view PestTest.php
    TestSuite

    Expect g:test#last_command == 'pest --colors'
  end

  it "runs test suites on normal tests"
    view NormalTest.php
    TestSuite

    Expect g:test#last_command == 'pest --colors'
  end

  it "doesn't recognize files that don't end with 'Test'"
    view normal.php
    TestFile

    Expect exists('g:test#last_command') == 0
  end

end
