source spec/support/helpers.vim

describe "CucumberJS - 7+"

  before
    cd spec/fixtures/cucumberjs7+
  end

  after
    call Teardown()
    cd -
  end

  it "runs selected scenario tests"
    view +6 features/normal.feature
    TestNearest

    Expect g:test#last_command == 'cucumber-js features/normal.feature:6'
  end

  it "runs nearest scenario tests"
    view +7 features/normal.feature
    TestNearest

    Expect g:test#last_command == 'cucumber-js features/normal.feature:6'
  end

  it "runs file tests"
    view features/normal.feature
    TestFile

    Expect g:test#last_command == 'cucumber-js features/normal.feature'
  end

  it "runs test suites"
    view features/normal.feature
    TestSuite

    Expect g:test#last_command == 'cucumber-js'
  end

  it "uses locally installed cucumber-js"
    try
      !mkdir -p node_modules/.bin
      !touch node_modules/.bin/cucumber-js

      view features/normal.feature
      TestSuite

      Expect g:test#last_command == 'node_modules/.bin/cucumber-js'
    finally
      " play it safe with the removal of files (i.e. no rm -rf)
      !rm node_modules/.bin/cucumber-js
      !rmdir node_modules/.bin
      !rmdir node_modules
    endtry
  end
end
