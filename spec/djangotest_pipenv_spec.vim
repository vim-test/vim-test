source spec/support/helpers.vim

describe "DjangoTest with Pipenv"

  before
    let g:test#python#runner = 'djangotest'
    cd spec/fixtures/django
    !touch Pipfile
  end

  after
    call Teardown()
    !rm Pipfile
    cd -
  end

  it "runs nearest tests"
    view +2 module/test_class.py
    TestNearest

    Expect g:test#last_command == 'pipenv run python manage.py test module.test_class.TestNumbers.test_numbers'

    view +5 module/test_class.py
    TestNearest

    Expect g:test#last_command == 'pipenv run python manage.py test module.test_class.TestSubclass'

    view +1 module/test_class.py
    TestNearest

    Expect g:test#last_command == 'pipenv run python manage.py test module.test_class.TestNumbers'

    view +1 module/test_method.py
    TestNearest

    Expect g:test#last_command == 'pipenv run python manage.py test module.test_method.test_numbers'
  end

  it "runs file test if nearest test couldn't be found"
    view +1 module/test_method.py
    normal O
    TestNearest

    Expect g:test#last_command == 'pipenv run python manage.py test module.test_method'
  end

  it "runs file tests"
    view module/test_class.py
    TestFile

    Expect g:test#last_command == 'pipenv run python manage.py test module.test_class'
  end

  it "runs test suites and finds manage.py"
    view test_class.py
    TestSuite

    Expect g:test#last_command == 'pipenv run python manage.py test'
  end

  it "runs django nose runner"
    let g:test#python#runner = 'djangonose'
    view +2 module/test_class.py
    TestNearest

    Expect g:test#last_command == 'pipenv run python manage.py test module.test_class:TestNumbers.test_numbers'
  end

end
