source spec/support/helpers.vim

describe "Peridot"

  before
    cd spec/fixtures/peridot
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests"
    view arrayobject.spec.php
    TestFile

    Expect g:test#last_command == './bin/peridot arrayobject.spec.php'
  end

  it "runs test suites"
    view arrayobject.spec.php
    TestSuite

    Expect g:test#last_command == './bin/peridot -g *.spec.php'
  end

end
