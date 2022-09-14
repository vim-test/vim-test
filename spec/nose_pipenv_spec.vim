source spec/support/helpers.vim

describe "Nose with Pipenv"

  before
    let g:test#python#runner = 'nose'
    cd spec/fixtures/nose_pipenv
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +1 test_class.py
    TestNearest

    Expect g:test#last_command == 'pipenv run nosetests --doctest-tests test_class.py:TestNumbers'
  end

  it "runs file tests"
    view test_class.py
    TestFile

    Expect g:test#last_command == 'pipenv run nosetests --doctest-tests test_class.py'
  end

  it "runs test suites"
    view test_class.py
    TestSuite

    Expect g:test#last_command == 'pipenv run nosetests --doctest-tests'
  end

end
