source spec/support/helpers.vim

describe "Mocha Webpack"

  before
    cd spec/fixtures/mocha-webpack
  end

  after
    call Teardown()
    cd -
  end

  context "on nearest tests"
    it "runs JavaScript"
      view +1 test/normal.js
      TestNearest

      Expect g:test#last_command == 'mocha-webpack test/normal.js --grep ''^Math'''

      view +2 test/normal.js
      TestNearest

      Expect g:test#last_command == 'mocha-webpack test/normal.js --grep ''^Math Addition'''

      view +3 test/normal.js
      TestNearest

      Expect g:test#last_command == 'mocha-webpack test/normal.js --grep ''^Math Addition adds two numbers$'''
    end

end
