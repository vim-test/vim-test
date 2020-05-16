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

  it "runs nearest tests"
    view +1 PestTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors PestTest.php"

    view +4 PestTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'is a test case' PestTest.php"

    view +8 PestTest.php
    TestNearest

    Expect g:test#last_command == "pest --colors --filter 'with a different descriptor' PestTest.php"
  end

  it "runs test suites"
    view PestTest.php
    TestSuite

    Expect g:test#last_command == 'pest --colors'
  end

  it "doesn't recognize files that don't end with 'Test'"
    view normal.php
    TestFile

    Expect exists('g:test#last_command') == 0
  end

end
