source spec/support/helpers.vim

describe "Intern"

  before
    cd spec/fixtures/intern
  end

  after
    call Teardown()
    cd -
  end

  context "BDD interface"
    it "runs nearest test"
      view +6 tests/bdd.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/bdd grep=''^Math - adds two numbers$'''

      view +15 tests/bdd.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/bdd grep=''^Math - Extra Math - multiplies two numbers$'''

      view +5 tests/bdd.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/bdd grep=''^Math - '''

      view +14 tests/bdd.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/bdd grep=''^Math - Extra Math - '''

      view +11 tests/unit/bdd.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/unit/bdd grep=''^Math - subtracts two numbers$'''

      view +20 tests/functional/bdd.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern functionalSuites=tests/functional/bdd grep=''^Math - Extra Math - divides two numbers$'''
    end

    it "runs file tests"
      view tests/bdd.js
      TestFile

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/bdd'

      view tests/unit/bdd.js
      TestFile

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/unit/bdd'

      view tests/functional/bdd.js
      TestFile

      Expect g:test#last_command == 'intern-client config=tests/intern functionalSuites=tests/functional/bdd'
    end

    it "runs test suites"
      view tests/bdd.js
      TestSuite

      Expect g:test#last_command == 'intern-client config=tests/intern'

      view tests/unit/bdd.js
      TestSuite

      Expect g:test#last_command == 'intern-client config=tests/intern'

      view tests/functional/bdd.js
      TestSuite

      Expect g:test#last_command == 'intern-client config=tests/intern'
    end
  end

  context "TDD interface"
    it "runs nearest test"
      view +6 tests/tdd.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/tdd grep=''^Math - adds two numbers$'''

      view +15 tests/tdd.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/tdd grep=''^Math - Extra Math - multiplies two numbers$'''

      view +5 tests/tdd.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/tdd grep=''^Math - '''

      view +14 tests/tdd.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/tdd grep=''^Math - Extra Math - '''

      view +11 tests/unit/tdd.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/unit/tdd grep=''^Math - subtracts two numbers$'''

      view +20 tests/functional/tdd.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern functionalSuites=tests/functional/tdd grep=''^Math - Extra Math - divides two numbers$'''
    end

    it "runs file tests"
      view tests/tdd.js
      TestFile

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/tdd'

      view tests/unit/tdd.js
      TestFile

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/unit/tdd'

      view tests/functional/tdd.js
      TestFile

      Expect g:test#last_command == 'intern-client config=tests/intern functionalSuites=tests/functional/tdd'
    end

    it "runs test suites"
      view tests/tdd.js
      TestSuite

      Expect g:test#last_command == 'intern-client config=tests/intern'

      view tests/unit/tdd.js
      TestSuite

      Expect g:test#last_command == 'intern-client config=tests/intern'

      view tests/functional/tdd.js
      TestSuite

      Expect g:test#last_command == 'intern-client config=tests/intern'
    end
  end

  context "Object interface"
    it "runs nearest test"
      view +7 tests/object.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/object grep=''^Math - adds two numbers$'''

      view +17 tests/object.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/object grep=''^Math - Extra Math - multiplies two numbers$'''

      view +5 tests/object.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/object grep=''^Math - '''

      view +15 tests/object.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/object grep=''^Math - Extra Math - '''

      view +12 tests/unit/object.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/unit/object grep=''^Math - subtracts two numbers$'''

      view +22 tests/functional/object.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern functionalSuites=tests/functional/object grep=''^Math - Extra Math - divides two numbers$'''
    end

    it "runs file tests"
      view tests/object.js
      TestFile

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/object'

      view tests/unit/object.js
      TestFile

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/unit/object'

      view tests/functional/object.js
      TestFile

      Expect g:test#last_command == 'intern-client config=tests/intern functionalSuites=tests/functional/object'
    end

    it "runs test suites"
      view tests/object.js
      TestSuite

      Expect g:test#last_command == 'intern-client config=tests/intern'

      view tests/unit/object.js
      TestSuite

      Expect g:test#last_command == 'intern-client config=tests/intern'

      view tests/functional/object.js
      TestSuite

      Expect g:test#last_command == 'intern-client config=tests/intern'
    end
  end

  context "QUnit interface"
    it "runs nearest test"
      view +5 tests/qunit.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/qunit grep=''adds two numbers$'''

      view +13 tests/qunit.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/qunit grep=''multiplies two numbers$'''

      view +4 tests/qunit.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/qunit grep=''^Math - '''

      view +12 tests/qunit.js
      TestNearest

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/qunit grep=''^Extra Math - '''
    end

    it "runs file tests"
      view tests/qunit.js
      TestFile

      Expect g:test#last_command == 'intern-client config=tests/intern suites=tests/qunit'
    end

    it "runs test suites"
      view tests/qunit.js
      TestSuite

      Expect g:test#last_command == 'intern-client config=tests/intern'
    end
  end
end
