source spec/support/helpers.vim

describe "WebdriverIO"

  before
    cd spec/fixtures/webdriverio
  end

  after
    call Teardown()
    cd -
  end

  it "runs test file"
    view test/specs/example.js
    TestFile

    Expect g:test#last_command == 'wdio wdio.conf.js --spec test/specs/example.js'
  end

  it "runs nearest test"
    view +5 test/specs/example.js
    TestNearest

    Expect g:test#last_command == 'wdio wdio.conf.js --spec test/specs/example.js'
  end

  it "runs test suite"
    view test/specs/example.js
    TestSuite

    Expect g:test#last_command == 'wdio wdio.conf.js'
  end

end
