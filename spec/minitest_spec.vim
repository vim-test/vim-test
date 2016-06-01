source spec/support/helpers.vim

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
      view +3 classic_unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="classic_unit_test.rb" TESTOPTS="--name=''/Math/''"'

      view +4 classic_unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="classic_unit_test.rb" TESTOPTS="--name=''/Math::TestNumbers/''"'

      view +6 classic_unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="classic_unit_test.rb" TESTOPTS="--name=''/Math::TestNumbers\#test_method$/''"'

      view +11 rails_unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="rails_unit_test.rb" TESTOPTS="--name=''/MathTest\#test_double_quotes$/''"'

      view +15 rails_unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="rails_unit_test.rb" TESTOPTS="--name=''/MathTest\#test_single_quotes$/''"'

      view +19 rails_unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="rails_unit_test.rb" TESTOPTS="--name=''/MathTest\#test_single_quote_''\''''_inside$/''"'

      view +23 rails_unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="rails_unit_test.rb" TESTOPTS="--name=''/MathTest\#test_double_quote_\"_inside$/''"'

      view +27 rails_unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="rails_unit_test.rb" TESTOPTS="--name=''/MathTest\#test_pending_test$/''"'

      view +29 rails_unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="rails_unit_test.rb" TESTOPTS="--name=''/MathTest\#test_parentheses$/''"'
    end

    it "builds the correct regex in spec syntax"
      view +6 classic_spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="classic_spec_test.rb" TESTOPTS="--name=''/Math/''"'

      view +7 classic_spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="classic_spec_test.rb" TESTOPTS="--name=''/Math::TestNumbers/''"'

      view +8 classic_spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="classic_spec_test.rb" TESTOPTS="--name=''/Math::TestNumbers\#test_\d+_has double quotes$/''"'

      view +12 classic_spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="classic_spec_test.rb" TESTOPTS="--name=''/Math::TestNumbers\#test_\d+_has single quotes$/''"'

      view +16 classic_spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="classic_spec_test.rb" TESTOPTS="--name=''/Math::TestNumbers\#test_\d+_contains a ''\''''$/''"'

      view +20 classic_spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="classic_spec_test.rb" TESTOPTS="--name=''/Math::TestNumbers\#test_\d+_contains a \"$/''"'

      view +24 classic_spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="classic_spec_test.rb" TESTOPTS="--name=''/Math::TestNumbers\#test_\d+_contains \`backticks\`$/''"'

      view +28 classic_spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="classic_spec_test.rb" TESTOPTS="--name=''/Math::TestNumbers\#test_\d+_is pending$/''"'

      view +30 classic_spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="classic_spec_test.rb" TESTOPTS="--name=''/Math::TestNumbers\#test_\d+_has parentheses$/''"'

      view +32 classic_spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="classic_spec_test.rb" TESTOPTS="--name=''/Math::TestNumbers::Parentheses/''"'

      view +4 explicit_spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="explicit_spec_test.rb" TESTOPTS="--name=''/MathSpec/''"'

      view +5 explicit_spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="explicit_spec_test.rb" TESTOPTS="--name=''/MathSpec\#test_\d+_is$/''"'
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
