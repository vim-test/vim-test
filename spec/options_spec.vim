source spec/support/helpers.vim

describe 'Options'

  before
    cd spec/fixtures/rspec-other
  end

  after
    call Teardown()
    cd -
  end

  it "is forwarded through generic testing commands"
    view +1 spec/normal_spec.rb

    TestNearest --foo bar
    Expect g:test#last_command == 'rspec --foo bar spec/normal_spec.rb:1'

    TestFile --foo bar
    Expect g:test#last_command == 'rspec --foo bar spec/normal_spec.rb'

    TestSuite --foo bar
    Expect g:test#last_command == 'rspec --foo bar'

    TestLast --baz
    Expect g:test#last_command == 'rspec --foo bar --baz'

    TestLast
    Expect g:test#last_command == 'rspec --foo bar --baz'
  end

  it "remembers options passed when running last test"
    edit spec/normal_spec.rb
    TestNearest

    TestLast --foo
    Expect g:test#last_command == 'rspec spec/normal_spec.rb:1 --foo'

    TestLast
    Expect g:test#last_command == 'rspec spec/normal_spec.rb:1 --foo'
  end

end
