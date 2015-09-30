source spec/helpers.vim

describe "PHPUnit"

  before
    cd spec/fixtures/phpunit
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests"
    view NormalTest.php
    TestFile

    Expect g:test#last_command == 'phpunit --colors NormalTest.php'
  end

  it "runs nearest tests"
    view +1 NormalTest.php
    TestNearest

    Expect g:test#last_command == "phpunit --colors NormalTest.php"

	view +9 NormalTest.php
    TestNearest

    Expect g:test#last_command == "phpunit --colors NormalTest.php --filter 'testShouldAddTwoNumbers'"

    view +14 NormalTest.php
    TestNearest

    Expect g:test#last_command == "phpunit --colors NormalTest.php --filter 'testShouldSubtractTwoNumbers'"
  end

  it "runs test suites"
    view NormalTest.php
    TestSuite

    Expect g:test#last_command == 'phpunit --colors'
  end

  it "doesn't recognize files that don't end with 'Test'"
    view normal.php
    TestFile

    Expect exists('g:test#last_command') == 0
  end

end
