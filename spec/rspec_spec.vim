source spec/helpers.vim

describe "RSpec"

  before
    cd spec/fixtures/rspec
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +1 normal_spec.rb
    TestNearest

    Expect g:test#last_command == 'rspec normal_spec.rb:1'
  end

  it "runs file tests"
    view normal_spec.rb
    TestFile

    Expect g:test#last_command == 'rspec normal_spec.rb'
  end

  it "runs test suites"
    view normal_spec.rb
    TestSuite

    Expect g:test#last_command == 'rspec'
  end

end
