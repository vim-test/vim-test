source spec/support/helpers.vim

describe "Codeception"

  before
    cd spec/fixtures/codeception
  end

  after
    call Teardown()
    cd -
  end

  it "runs cest file tests"
    view tests/functional/NormalCest.php
    TestFile

    Expect g:test#last_command == 'codecept run tests/functional/NormalCest.php'
  end

  it "runs cept file tests"
    view tests/functional/NormalCept.php
    TestFile

    Expect g:test#last_command == 'codecept run tests/functional/NormalCept.php'
  end

  it "runs feature file tests"
    view tests/functional/Normal.feature
    TestFile

    Expect g:test#last_command == 'codecept run tests/functional/Normal.feature'
  end

  it "runs unit test file"
    view tests/functional/NormalTest.php
    TestFile

    Expect g:test#last_command == 'codecept run tests/functional/NormalTest.php'
  end

  it "runs cest nearest tests"
    view +21 tests/functional/NormalCest.php
    TestNearest

    Expect g:test#last_command ==
          \ 'codecept run tests/functional/NormalCest.php:tryToTestSomethingElse'
  end

  it "runs cept nearest tests"
    view +3 tests/functional/NormalCept.php
    TestNearest

    Expect g:test#last_command == 'codecept run tests/functional/NormalCept.php'
  end

  it "runs feature nearest tests"
    view +1 tests/functional/Normal.feature
    TestNearest

    Expect g:test#last_command == 'codecept run tests/functional/Normal.feature'
  end

  it "runs nearest unit tests"
    view +23 tests/functional/NormalTest.php
    TestNearest

    Expect g:test#last_command ==
          \ 'codecept run tests/functional/NormalTest.php:testMe'
  end

  it "runs test suites"
    view tests/functional/NormalCest.php
    TestSuite

    Expect g:test#last_command == 'codecept run'
  end

  it "doesn't recognize files that don't end with 'Cest', 'Cept' or 'Test'"
    view tests/functional/normal.php
    TestFile

    Expect exists('g:test#last_command') == 0
  end

end
