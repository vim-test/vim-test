source spec/support/helpers.vim

describe "PyUnit with Pipenv"

  before
    let g:test#python#runner = 'pyunit'
    cd spec/fixtures/pytest_pipenv
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +1 test_class.py
    TestNearest

    Expect g:test#last_command == 'pipenv run python -m unittest test_class.TestNumbers'
  end

  it "runs file tests"
    view test_class.py
    TestFile

    Expect g:test#last_command == 'pipenv run python -m unittest test_class'
  end

  it "runs test suites"
    view test_class.py
    TestSuite

    Expect g:test#last_command == 'pipenv run python -m unittest'
  end

end
