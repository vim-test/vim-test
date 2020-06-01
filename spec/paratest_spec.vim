source spec/support/helpers.vim

describe "ParaTest"

  before
    cd spec/fixtures/phpunit
    !mkdir vendor
    !mkdir vendor/bin
    !touch vendor/bin/paratest
  end

  after
    !rm -f vendor/bin/*
    call Teardown()
    cd -
  end

  it "runs file tests"
    !touch vendor/bin/paratest
    view NormalTest.php
    TestFile

    Expect g:test#last_command == './vendor/bin/paratest --colors NormalTest.php'
  end

  it "runs test suites"
    view NormalTest.php
    TestSuite

    Expect g:test#last_command == './vendor/bin/paratest --colors'
  end

  it "runs in functional mode for TestNearest with --filter"
    view +1 NormalTest.php
    TestNearest

    Expect g:test#last_command == "./vendor/bin/paratest --colors NormalTest.php"

    view +9 NormalTest.php
    TestNearest

    Expect g:test#last_command == "./vendor/bin/paratest --colors --functional --filter '::testShouldAddTwoNumbers' NormalTest.php"
  end
end
