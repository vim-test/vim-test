source spec/support/helpers.vim

describe "rackunit"

  before
    cd spec/fixtures/rackunit
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests"
    view testrackunit.rkt
    TestFile

    Expect g:test#last_command == 'racket testrackunit.rkt'
  end

end
