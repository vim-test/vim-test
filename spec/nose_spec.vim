source spec/helpers.vim

function! LastCommand() abort
  return substitute(g:test#last_command.value, ' --doctest-tests', '', '')
endfunction

describe "Nose"

  before
    let g:test#python#runner = 'nose'
    cd spec/fixtures/nose
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +2 test_class.py
    TestNearest

    Expect LastCommand() == 'nosetests test_class.py:TestNumbers.test_numbers'

    view +1 test_class.py
    TestNearest

    Expect LastCommand() == 'nosetests test_class.py:TestNumbers'

    view +1 test_method.py
    TestNearest

    Expect LastCommand() == 'nosetests test_method.py:test_numbers'
  end

  it "runs file test if nearest test couldn't be found"
    view +1 test_method.py
    normal O
    TestNearest

    Expect LastCommand() == 'nosetests test_method.py'
  end

  it "runs file tests"
    view test_class.py
    TestFile

    Expect LastCommand() == 'nosetests test_class.py'
  end

  it "runs test suites"
    view test_class.py
    TestSuite

    Expect LastCommand() == 'nosetests'
  end

end
