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
    it "works with unit syntax"
      view +1 unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="unit_test.rb" TESTOPTS="--name=''/TestNumbers/''"'

      view +2 unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="unit_test.rb" TESTOPTS="--name=''/test_method/''"'

      view +6 unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="unit_test.rb" TESTOPTS="--name=''/double quotes/''"'

      view +10 unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="unit_test.rb" TESTOPTS="--name=''/single quotes/''"'

      view +14 unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="unit_test.rb" TESTOPTS="--name=''/single quote ''\'''' inside/''"'

      view +18 unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="unit_test.rb" TESTOPTS="--name=''/double quote \" inside/''"'

      view +22 unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="unit_test.rb" TESTOPTS="--name=''/pending test/''"'
    end

    it "works with spec syntax"
      view +1 unit_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="unit_test.rb" TESTOPTS="--name=''/TestNumbers/''"'

      view +2 spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="spec_test.rb" TESTOPTS="--name=''/has double quotes/''"'

      view +6 spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="spec_test.rb" TESTOPTS="--name=''/has single quotes/''"'

      view +10 spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="spec_test.rb" TESTOPTS="--name=''/contains a ''\''''/''"'

      view +14 spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="spec_test.rb" TESTOPTS="--name=''/contains a \"/''"'

      view +18 spec_test.rb
      TestNearest

      Expect g:test#last_command == 'rake test TEST="spec_test.rb" TESTOPTS="--name=''/is pending/''"'
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

    Expect g:test#last_command == 'rake test'
  end

  it "runs folders recursively"
    view unit_test.rb
    Minitest .

    Expect g:test#last_command == 'rake test TEST="**/*_test.rb"'
  end

end
