source spec/support/helpers.vim

describe "Karma"

  describe "with executable"
    before
      cd spec/fixtures/karma
    end

    after
      call Teardown()
      cd -
    end

    it "runs nearest tests"
      SKIP "Disabled until functionality is implemented"
      view +2 normal_spec.js
      TestNearest

      Expect g:test#last_command == 'karma start --single-run -- spec/normal_spec.js --filter=''Addition adds two numbers'''
    end

    it "runs file tests"
      SKIP "Disabled until functionality is implemented"
      view normal_spec.js
      TestFile

      Expect g:test#last_command == 'karma start --single-run -- spec/normal_spec.js'
    end

    it "runs test suites"
      view normal_spec.js
      TestSuite

      Expect g:test#last_command == 'node_modules/.bin/karma start --single-run'
    end

    it "detects tests in files ending with 'test'"
      view normal_test.js
      TestSuite

      Expect g:test#last_command == 'node_modules/.bin/karma start --single-run'
    end

    it "is case insensitive about the filename"
      view normalSpec.js
      TestSuite

      Expect g:test#last_command == 'node_modules/.bin/karma start --single-run'
    end

    it "doesn't recognize files that don't end with 'spec' or 'test'"
      view normal.js
      TestFile

      Expect exists('g:test#last_command') == 0
    end

    it "runs CoffeeScript"
      view spec/normal_spec.coffee
      TestSuite

      Expect g:test#last_command == 'node_modules/.bin/karma start --single-run'
    end

    it "runs React"
      view spec/normal_spec.jsx
      TestSuite

      Expect g:test#last_command == 'node_modules/.bin/karma start --single-run'
    end
  end

  describe "without executable"
    after
      call Teardown()
    end

    it "doesn't run test suites"
      view normal_spec.js
      TestSuite

      Expect exists('g:test#last_command') == 0
    end
  end
end
