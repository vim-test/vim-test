source spec/support/helpers.vim

describe "TestBench"
  before
    cd spec/fixtures/testbench
  end

  after
    unlet! g:test#ruby#bundle_exec
    call Teardown()
    cd -
  end

  it "runs file tests"
    view test/automated/math.rb
    TestFile

    Expect g:test#last_command == 'bundle exec bench test/automated/math.rb'
  end

  " TestBench currently isn't capable of running a single test within a file
  it "runs nearest tests like file tests"
    view +1 test/automated/math.rb
    TestNearest

    Expect g:test#last_command == 'bundle exec bench test/automated/math.rb'
  end

  it "runs test suites"
    view test/automated/math.rb
    TestSuite

    Expect g:test#last_command == 'bundle exec bench test/automated/'
  end

  it "respects g:test#ruby#bundle_exec"
    let g:test#ruby#bundle_exec = 0
    view test/automated/math.rb
    TestFile

    Expect g:test#last_command == 'bench test/automated/math.rb'
  end
end
