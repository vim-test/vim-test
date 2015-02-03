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

    Expect LastCommand() == 'rspec normal_spec.rb:1'
  end

  it "runs file tests"
    view normal_spec.rb
    TestFile

    Expect LastCommand() == 'rspec normal_spec.rb'
  end

  it "runs test suites"
    view normal_spec.rb
    TestSuite

    Expect LastCommand() == 'rspec'
  end

end
