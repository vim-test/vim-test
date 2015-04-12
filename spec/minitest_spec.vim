source spec/helpers.vim

describe "Minitest"

  before
    cd spec/fixtures/minitest
  end

  after
    call Teardown()
    cd -
  end

  context "on nearest tests"
    it "builds the correct regex in unit syntax"
      view +3 unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="unit_test.rb" TESTOPTS="--name=''/Math/''"'

      view +4 unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="unit_test.rb" TESTOPTS="--name=''/Math::TestNumbers/''"'

      view +12 unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="unit_test.rb" TESTOPTS="--name=''/Math::TestNumbers\#test_method/''"'

      view +16 unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="unit_test.rb" TESTOPTS="--name=''/Math::TestNumbers\#test_double_quotes/''"'

      view +20 unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="unit_test.rb" TESTOPTS="--name=''/Math::TestNumbers\#test_single_quotes/''"'

      view +24 unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="unit_test.rb" TESTOPTS="--name=''/Math::TestNumbers\#test_single_quote_''\''''_inside/''"'

      view +28 unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="unit_test.rb" TESTOPTS="--name=''/Math::TestNumbers\#test_double_quote_\"_inside/''"'

      view +32 unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="unit_test.rb" TESTOPTS="--name=''/Math::TestNumbers\#test_pending_test/''"'
    end

    it "builds the correct regex in spec syntax"
      view +6 spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="spec_test.rb" TESTOPTS="--name=''/Math/''"'

      view +7 spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="spec_test.rb" TESTOPTS="--name=''/Math::TestNumbers/''"'

      view +8 spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="spec_test.rb" TESTOPTS="--name=''/Math::TestNumbers\#test_\d+_has double quotes/''"'

      view +12 spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="spec_test.rb" TESTOPTS="--name=''/Math::TestNumbers\#test_\d+_has single quotes/''"'

      view +16 spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="spec_test.rb" TESTOPTS="--name=''/Math::TestNumbers\#test_\d+_contains a ''\''''/''"'

      view +20 spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="spec_test.rb" TESTOPTS="--name=''/Math::TestNumbers\#test_\d+_contains a \"/''"'

      view +24 spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="spec_test.rb" TESTOPTS="--name=''/Math::TestNumbers\#test_\d+_is pending/''"'
    end
  end

  it "runs file test if nearest test couldn't be found"
    view +1 unit_test.rb
    normal O
    TestNearest

    Expect g:test#last_command == 'rake test TEST="unit_test.rb"'
  end

  it "runs file tests"
    view unit_test.rb
    TestFile

    Expect g:test#last_command == 'rake test TEST="unit_test.rb"'
  end

  it "runs test suites"
    view unit_test.rb
    TestSuite

    Expect g:test#last_command == 'rake test TEST="test/**/*_test.rb"'
  end

  it "runs folders recursively"
    view unit_test.rb
    Minitest .

    Expect g:test#last_command == 'rake test TEST="**/*_test.rb"'
  end

  it "switches to reliable option passing"
    view unit_test.rb
    Minitest --name /some_regex/

    Expect g:test#last_command == 'rake test TEST="test/**/*_test.rb" TESTOPTS="--name=''/some_regex/''"'

    view unit_test.rb
    Minitest --seed 1234

    Expect g:test#last_command == 'rake test TEST="test/**/*_test.rb" TESTOPTS="--seed=''1234''"'
  end

end
