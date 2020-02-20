source spec/support/helpers.vim

describe "Vroom"

  before
    let g:test#enabled_runners = ['viml#vroom']
    cd spec/fixtures/vroom
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests instead of nearest tests"
    view +3 math.vroom
    TestNearest

    Expect g:test#last_command == 'vroom math.vroom'
  end

  it "runs file tests"
    view math.vroom
    TestFile

    Expect g:test#last_command == 'vroom math.vroom'
  end

  it "runs test suite"
    view math.vroom
    TestSuite

    Expect g:test#last_command == 'vroom --crawl .'
  end

end
