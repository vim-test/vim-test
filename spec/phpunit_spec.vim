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

    Expect g:test#last_command == 'phpunit NormalTest.php'
  end

  it "runs test suites"
    view NormalTest.php
    TestSuite

    Expect g:test#last_command == 'phpunit'
  end

  it "doesn't recognize files that don't end with 'Test'"
    view normal.php
    TestFile

    Expect exists('g:test#last_command') == 0
  end

end
