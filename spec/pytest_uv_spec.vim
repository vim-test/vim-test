source spec/support/helpers.vim

describe "PyTest with uv"

  before
    let g:test#python#runner = 'pytest'
    cd spec/fixtures/pytest
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

    Expect g:test#last_command == 'uv run pytest test_class.py'
  end

end
