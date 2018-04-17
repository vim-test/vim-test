source spec/support/helpers.vim

describe 'Main'

  before
    cd spec/fixtures/rspec-other
  end

  after
    call Teardown()
    cd -
  end

  it "runs tests on different granularities"
    view +2 spec/normal_spec.rb

    TestNearest
    Expect g:test#last_command == 'rspec spec/normal_spec.rb:2'

    TestFile
    Expect g:test#last_command == 'rspec spec/normal_spec.rb'

    TestSuite
    Expect g:test#last_command == 'rspec'
  end

  it "remembers the last test-run position when not on test file"
    edit spec/normal_spec.rb
    TestFile

    edit foo.txt
    TestFile

    Expect g:test#last_command == 'rspec spec/normal_spec.rb'
  end

  it "runs last test"
    edit spec/normal_spec.rb
    TestNearest

    edit bar_spec.rb
    TestLast

    Expect g:test#last_command == 'rspec spec/normal_spec.rb:1'
  end

  it "doesn't raise an error when unable to run tests"
    edit foo.txt
    TestNearest | TestFile | TestSuite | TestLast
  end

  it "can go to the last run test"
    edit +3 spec/normal_spec.rb
    TestNearest

    edit foo.txt
    TestVisit

    Expect expand('%') == 'spec/normal_spec.rb'
    Expect line('.') == 3
  end

  it "generates paths according to the filename modifier"
    let g:test#filename_modifier = ':p'

    view spec/normal_spec.rb
    TestFile

    Expect g:test#last_command == 'rspec '.getcwd().'/spec/normal_spec.rb'

    unlet g:test#filename_modifier
  end
end
