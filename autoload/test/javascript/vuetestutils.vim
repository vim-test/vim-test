if !exists('g:test#javascript#vuetestutils#file_pattern')
  let g:test#javascript#vuetestutils#file_pattern = '\v(__tests__/.*|(spec|test))\.(js|jsx|coffee|ts|tsx)$'
endif

function! test#javascript#vuetestutils#test_file(file) abort
  if a:file =~# g:test#javascript#vuetestutils#file_pattern
      if exists('g:test#javascript#runner')
          return g:test#javascript#runner ==# 'vue-cli-service'
      else
        return test#javascript#has_package('@vue/test-utils')
      endif
  endif
endfunction

function! test#javascript#vuetestutils#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      let name = '-t '.shellescape(name, 1)
    endif
    return [name, '--', a:position['file']]
  elseif a:type ==# 'file'
    return ['--', a:position['file']]
  else
    return []
  endif
endfunction

function! test#javascript#vuetestutils#build_args(args) abort
  if exists('g:test#javascript#vuetestutils#executable')
    \ && g:test#javascript#vuetestutils#executable =~# s:yarn_command
    return filter(a:args, 'v:val != "--"')
  else
    return a:args
  endif
endfunction

function! test#javascript#vuetestutils#executable() abort
  return "vue-cli-service test:unit"
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return (len(name['namespace']) ? '^' : '') .
       \ test#base#escape_regex(join(name['namespace'] + name['test'])) .
       \ (len(name['test']) ? '$' : '')
endfunction

