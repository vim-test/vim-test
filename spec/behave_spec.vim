source spec/support/helpers.vim

describe "Behave"
  before
    let g:test#python#runner = 'behave'
    cd spec/fixtures/behave
  end

  after
    call Teardown()
    cd -
  end

  it ":TestFile"
    view +1 features/test.feature
    TestFile
    Expect g:test#last_command == 'behave features/test.feature'
  end

  it ":TestNearest"
    view +5 features/test.feature
    TestNearest
    Expect g:test#last_command == 'behave features/test.feature:5'
  end

  it ":TestSuite"
    view +1 features/test.feature
    TestSuite
    Expect g:test#last_command == 'behave'
  end

end
