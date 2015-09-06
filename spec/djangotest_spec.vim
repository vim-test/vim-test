source spec/helpers.vim

function! test#shell(cmd) abort
  " Simplify test path to django fixtures directory.
  let fixture_path = g:test#plugin_path . '/spec/fixtures/django/'
  let g:test#last_command = substitute(a:cmd, fixture_path, '', '')
endfunction

describe "DjangoTest"

  before
    let g:test#python#runner = 'djangotest'
    cd spec/fixtures/django
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +2 module/test_class.py
    TestNearest

    Expect g:test#last_command == 'manage.py test module.test_class.TestNumbers.test_numbers'

    view +5 module/test_class.py
    TestNearest

    Expect g:test#last_command == 'manage.py test module.test_class.TestSubclass'

    view +1 module/test_class.py
    TestNearest

    Expect g:test#last_command == 'manage.py test module.test_class.TestNumbers'

    view +1 module/test_method.py
    TestNearest

    Expect g:test#last_command == 'manage.py test module.test_method.test_numbers'
  end

  it "runs file test if nearest test couldn't be found"
    view +1 module/test_method.py
    normal O
    TestNearest

    Expect g:test#last_command == 'manage.py test module.test_method'
  end

  it "runs file tests"
    view module/test_class.py
    TestFile

    Expect g:test#last_command == 'manage.py test module.test_class'
  end

  it "runs test suites and finds manage.py"
    view test_class.py
    TestSuite

    Expect g:test#last_command == 'manage.py test'
  end

end
