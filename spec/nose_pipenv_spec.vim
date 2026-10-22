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

  context "when project root is in a subdirectory"
    before
      cd ..
    end

    it "runs file tests from directory with root marker"
      let cwd_initial = getcwd()
      view nose_pipenv/test_class.py
      TestFile

      Expect g:test#last_command == 'pipenv run nosetests --doctest-tests test_class.py'
      Expect getcwd() == cwd_initial
    end
  end
end
