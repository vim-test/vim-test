source spec/support/helpers.vim

describe "vue-test-utils"

  before
    cd spec/fixtures/vue-test-utils
  end

  after
    call Teardown()
    cd -
  end

  context "on nearest tests"
    it "runs vue-cli-service"
      view +1 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'vue-cli-service test:unit -t ''^Math'' -- __tests__/normal-test.js'

      view +2 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'vue-cli-service test:unit -t ''^Math Addition'' -- __tests__/normal-test.js'

      view +3 __tests__/normal-test.js
      TestNearest

      Expect g:test#last_command == 'vue-cli-service test:unit -t ''^Math Addition adds two numbers$'' -- __tests__/normal-test.js'
    end

    it "aliases context to describe"
      view +1 __tests__/context-test.js
      TestNearest

      Expect g:test#last_command == 'vue-cli-service test:unit -t ''^Math'' -- __tests__/context-test.js'

      view +2 __tests__/context-test.js
      TestNearest

      Expect g:test#last_command == 'vue-cli-service test:unit -t ''^Math Addition'' -- __tests__/context-test.js'

      view +3 __tests__/context-test.js
      TestNearest

      Expect g:test#last_command == 'vue-cli-service test:unit -t ''^Math Addition adds two numbers$'' -- __tests__/context-test.js'
    end

   end

   it "runs file test if nearest test couldn't be found"
     view +1 __tests__/normal-test.js
     normal O
     TestNearest

     Expect g:test#last_command == 'vue-cli-service test:unit -- __tests__/normal-test.js'
   end

   it "runs file tests"
     view __tests__/normal-test.js
     TestFile

     Expect g:test#last_command == 'vue-cli-service test:unit -- __tests__/normal-test.js'
   end

   it "runs test suites"
     view __tests__/normal-test.js
     TestSuite

     Expect g:test#last_command == 'vue-cli-service test:unit'
   end

   it "runs tests outside of __tests__"
     view outside-test.js
     TestFile

     Expect g:test#last_command == 'vue-cli-service test:unit -- outside-test.js'
   end
end
