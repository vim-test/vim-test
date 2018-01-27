source spec/support/helpers.vim

describe "PHPSpec"

  before
    cd spec/fixtures/phpspec
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests"
    view NormalSpec.php
    TestFile

    Expect g:test#last_command == 'phpspec run NormalSpec.php'
  end

  it "runs nearest tests"
    view +11 NormalSpec.php
    TestNearest

    Expect g:test#last_command == 'phpspec run NormalSpec.php:11'
  end

  it "runs test suites"
    view NormalSpec.php
    TestSuite

    Expect g:test#last_command == 'phpspec run'
  end

  it "doesn't recognize files that don't end with 'Spec'"
    view normal.php
    TestFile

    Expect exists('g:test#last_command') == 0
  end

end
