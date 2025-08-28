source spec/support/helpers.vim

describe "Nose with uv"

  before
    let g:test#python#runner = 'nose'
    cd spec/fixtures/nose
    !touch uv.lock
  end

  after
    !rm uv.lock
    call Teardown()
    cd -
  end

  it "runs file tests"
    view test_class.py
    TestFile

    Expect g:test#last_command == 'uv run nosetests --doctest-tests test_class.py'
  end

end
