source spec/support/helpers.vim

describe "Catch2"

  before
    cd spec/fixtures/catch2
  end

  after
    call Teardown()
    cd -
  end
  it "runs file tests"
    view +16 test_catch.cpp
    TestFile
    Expect g:test#last_command =~ './test_catch'
  end

  it "run nearest test when nearest test is a TEST_CASE_METHOD"
    view +38 test_catch.cpp
    TestNearest
    Expect g:test#last_command =~ "./test_catch 'sum'"
  end

  it "runs test suites"
    view test_catch.cpp
    TestSuite
    Expect g:test#last_command =~ 'ctest'
  end

end
