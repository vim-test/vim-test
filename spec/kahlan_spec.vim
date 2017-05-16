source spec/support/helpers.vim

describe "Kahlan"

  before
    cd spec/fixtures/kahlan
  end

  after
    call Teardown()
    cd -
  end

  it "runs test suites"
    view spec/Normal.spec.php
    TestSuite

    Expect g:test#last_command == './bin/kahlan'
  end

end
