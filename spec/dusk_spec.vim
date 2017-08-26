source spec/support/helpers.vim

describe "Dusk"

  before
    cd spec/fixtures/dusk
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests"
    view BrowserTest.php
    TestFile

    Expect g:test#last_command == 'php artisan dusk --colors BrowserTest.php'
  end

  it "runs nearest tests"
    view +1 BrowserTest.php
    TestNearest

    Expect g:test#last_command == "php artisan dusk --colors BrowserTest.php"

    view +10 BrowserTest.php
    TestNearest

    Expect g:test#last_command == "php artisan dusk --colors --filter 'testShouldAddTwoNumbers' BrowserTest.php"

    view +15 BrowserTest.php
    TestNearest

    Expect g:test#last_command == "php artisan dusk --colors --filter 'testShouldSubtractTwoNumbers' BrowserTest.php"

    view +31 BrowserTest.php
    TestNearest

    Expect g:test#last_command == "php artisan dusk --colors --filter 'testShouldAddToExpectedValue' BrowserTest.php"
  end
end
