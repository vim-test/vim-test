source spec/support/helpers.vim

describe "Language runner strategy"

  before
    cd spec/fixtures/jest

    function! TermStrategy(cmd)
        let g:test#last_command = 'test#strategy worked!'
    endfunction

    function! JsTermStrategy(cmd)
        let g:test#last_command = 'specified language runner strategy worked!'
    endfunction
  end

  after
    unlet g:test#last_command
    call Teardown()
    cd -
  end

  it "can be specified and work fine"
    let g:test#custom_strategies = {'jsTermOpen': function('JsTermStrategy')}
    let g:test#javascript#jest#strategy = 'jsTermOpen'

    view +1 __tests__/normal-test.js
    TestNearest

    Expect g:test#last_command == 'specified language runner strategy worked!'
    unlet g:test#javascript#jest#strategy 
  end

  it 'if not be specified, test#strategy will work'
    let g:test#custom_strategies = {'termOpen': function('TermStrategy')}
    let g:test#strategy = 'termOpen'

    view +1 __tests__/normal-test.js
    TestNearest

    Expect g:test#last_command == 'test#strategy worked!'
  end

  it "has higher priority then test#strategy"
    let g:test#custom_strategies = {'termOpen': function('TermStrategy'), 'jsTermOpen': function('JsTermStrategy')}
    let g:test#javascript#jest#strategy = 'jsTermOpen'

    view +1 __tests__/normal-test.js
    TestNearest
    Expect g:test#last_command == 'specified language runner strategy worked!'

    let g:test#strategy = 'termOpen'
    TestNearest
    Expect g:test#last_command == 'specified language runner strategy worked!'
    unlet g:test#javascript#jest#strategy 
  end
end
