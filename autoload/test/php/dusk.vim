if !exists('g:test#php#dusk#file_pattern')
  let g:test#php#dusk#file_pattern = '\v(t|T)est\.php$'
endif

function! test#php#dusk#test_file(file) abort
  return a:file =~# g:test#php#dusk#file_pattern
    \ && !empty(filter(readfile(a:file), 'v:val =~# ''use Laravel\\Dusk\\Browser'''))
endfunction

function! test#php#dusk#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name) | let name = '--filter '.shellescape(name, 1) | endif
    return [name, a:position['file']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#php#dusk#build_args(args) abort
  let args = a:args

  if !test#base#no_colors()
    let args = ['--colors'] + args
  endif

  return args
endfunction

function! test#php#dusk#executable() abort
  if filereadable('/usr/local/bin/php/artisan')
    return './usr/local/bin/php/artisan dusk'
  else
    return 'php artisan dusk'
  end
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#php#patterns)
  return join(name['test'])
endfunction
