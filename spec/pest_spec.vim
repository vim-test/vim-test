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

  it  "runs nearest test marked with @test annotation"
    view +40 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'aTestMarkedWithTestAnnotation' NormalTest.php"

    view +50 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'aTestMarkedWithTestAnnotationAndCrazyDocblock' NormalTest.php"
  end

  it  "runs nearest test containing an anonymous class"
    view +61 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'testWithAnAnonymousClass' NormalTest.php"

    view +76 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'aTestMakedWithTestAnnotationAndWithAnAnonymousClass' NormalTest.php"
  end

  it "runs nearest tests on normal test"
    view +1 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors NormalTest.php"

    view +9 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'testShouldAddTwoNumbers' NormalTest.php"

    view +14 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'testShouldSubtractTwoNumbers' NormalTest.php"

    view +30 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'testShouldAddToExpectedValue' NormalTest.php"
  end

  it "runs nearest test with a one line @test annotation"
    view +83 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'aTestMarkedWithTestAnnotationOnOneLine' NormalTest.php"
  end

  it "runs nearest test with a one line #[Test] attribute"
    view +87 NormalTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'aTestMarkedWithTestAttributeOnOneLine' NormalTest.php"
  end

  it "runs nearest test with a one line #[Test] attribute in a group"
    view +93 NormalTest.php
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
