source spec/support/helpers.vim

describe "PyUnit with uv"

  before
    let g:test#python#runner = 'pyunit'
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

    Expect g:test#last_command == 'uv run python3 -m unittest test_class'
  end

end
