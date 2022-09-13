source spec/support/helpers.vim

describe "ShellSpec"

  before
    cd spec/fixtures/shellspec
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest test"
    view +11 normal_spec.sh
    TestNearest

    Expect g:test#last_command == 'shellspec normal_spec.sh -E ''one'''

    view +14 normal_spec.sh
    TestNearest

    Expect g:test#last_command == 'shellspec normal_spec.sh -E ''one not two'''

    view +19 normal_spec.sh
    TestNearest

    Expect g:test#last_command == 'shellspec normal_spec.sh -E ''two'''
  end

  it "runs file tests"
    view normal_spec.sh
    TestFile

    Expect g:test#last_command == 'shellspec normal_spec.sh'
  end

  it "runs test suites"
    view normal_spec.sh
    TestSuite

    Expect g:test#last_command == 'shellspec spec/'
  end

end
