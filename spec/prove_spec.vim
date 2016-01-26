source spec/helpers.vim

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
    view normal.php
    Prove t/

    Expect g:test#last_command == 'prove -l --recurse t/'
  end

end
