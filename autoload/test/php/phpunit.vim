if !exists('g:test#php#phpunit#file_pattern')
  let g:test#php#phpunit#file_pattern = '\v(t|T)est\.php$'
endif

function! test#php#phpunit#test_file(file) abort
  return a:file =~# g:test#php#phpunit#file_pattern
endfunction

function! test#php#phpunit#build_position(type, position) abort
  if a:type == 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name) | let name = '--filter '.shellescape(name, 1) | endif
    return [name, a:position['file']]
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#php#phpunit#build_args(args) abort
  let args = a:args

  if !test#base#no_colors()
    let args = ['--colors'] + args
  endif

  return args
endfunction

function! test#php#phpunit#executable() abort
  if filereadable('./vendor/bin/phpunit')
    return './vendor/bin/phpunit'
  elseif filereadable('./bin/phpunit')
    return './bin/phpunit'
  else
    return 'phpunit'
  endif
endfunction

function! s:search_local_executable(dir) abort
  " Look for phpunit in Composer's vendor/bin and Symfony's bin directories
  echo a:dir
  if filereadable(a:dir . '/vendor/bin/phpunit')
    return a:dir . '/vendor/bin/phpunit'
  elseif filereadable(a:dir . '/bin/phpunit')
    return a:dir . '/bin/phpunit'
  else
    return ''
  endif
endfunction

function! test#php#phpunit#executable() abort
  let phpunit_path = ''
  let search_count = 0
  let search_base_dir = expand("%:p:h")
  while search_count < g:test#executable_search_depth
    let phpunit_path = s:search_local_executable(search_base_dir)
    if phpunit_path != ''
        break
    endif
    let search_base_dir = search_base_dir . '/..'
    let search_count = search_count + 1
  endwhile

  if filereadable(phpunit_path)
    return phpunit_path
  else
    return 'phpunit'
  endif
endfunction

function! s:nearest_test(position)
  let name = test#base#nearest_test(a:position, g:test#php#patterns)
  return join(name['test'])
endfunction
