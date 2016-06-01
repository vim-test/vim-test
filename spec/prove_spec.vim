source spec/support/helpers.vim

describe "Prove"

  before
    cd spec/fixtures/prove
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests"
    view t/math_test.t

    TestFile
    Expect g:test#last_command == 'prove -l t/math_test.t'

    TestNearest
    Expect g:test#last_command == 'prove -l t/math_test.t'
  end

  it "runs suite"
    view t/math_test.t
    TestSuite

    Expect g:test#last_command == 'prove -l'
  end

  it "recurses into directories"
    view t/math_test.t
    Prove t/

    Expect g:test#last_command == 'prove -l --recurse t/'
  end

  it "handles test arguments"
    view t/math_test.t

    TestFile :: --foo bar
    Expect g:test#last_command == 'prove -l t/math_test.t :: --foo bar'

    TestFile --verbose :: --foo bar
    Expect g:test#last_command == 'prove -l --verbose t/math_test.t :: --foo bar'
  end

end
