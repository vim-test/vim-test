source spec/support/helpers.vim

describe "Rspec binstub"

  before
    cd spec/fixtures/rspec-binstub
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +1 spec/normal_spec.rb
    TestNearest

    Expect g:test#last_command == 'bin/rspec spec/normal_spec.rb:1'
  end

  it "runs file tests"
    view spec/normal_spec.rb
    TestFile

    Expect g:test#last_command == 'bin/rspec spec/normal_spec.rb'
  end

  it "runs test suites"
    view spec/normal_spec.rb
    TestSuite

    Expect g:test#last_command == 'bin/rspec'
  end

end
