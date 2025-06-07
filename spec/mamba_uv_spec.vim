source spec/support/helpers.vim

describe "Mamba with uv"
  before
    let g:test#python#runner = 'mamba'
    cd spec/fixtures/mamba
    !touch uv.lock
  end

  after
    !rm uv.lock
    call Teardown()
    cd -
  end

  it "runs file tests"
    view normal_spec.py
    TestFile

    Expect g:test#last_command == 'uv run mamba normal_spec.py'
  end
end
