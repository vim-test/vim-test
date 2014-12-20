let test#minitest#compiler = 'rubyunit'

function! test#minitest#test_file(file) abort
  return a:file =~# '_test\.rb$'
endfunction

function! test#minitest#build_position(type, position) abort
  if a:type == 'nearest'
    let name = test#minitest#nearest_test(a:position)
    if !empty(name) | let name = '--name='.shellescape('/'.name.'/', 1) | endif
    return [a:position['file'], name]
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#minitest#build_args(args) abort
  for idx in range(0, len(a:args) - 1)
    if test#file_exists(a:args[idx])
      let path = remove(a:args, idx) | break
    endif
  endfor

  if exists('path') && isdirectory(path)
    let path = fnamemodify(path, ':p:.') . '**/*_test.rb'
  endif

  let cmd = []
  if exists('path') | call add(cmd, 'TEST="'.escape(path, '"').'"') | endif
  if !empty(a:args) | call add(cmd, 'TESTOPTS="'.escape(join(a:args), '"').'"') | endif

  return cmd
endfunction

function! test#minitest#executable() abort
  if filereadable('.zeus.sock')
    return 'zeus rake test'
  elseif filereadable('./bin/rake')
    return './bin/rake test'
  elseif filereadable('Gemfile')
    return 'bundle exec rake test'
  else
    return 'rake test'
  endif
endfunction

function! test#minitest#nearest_test(position) abort
  for line in reverse(getbufline(a:position['file'], 1, a:position['line']))
    if line =~# '\v^\s*(describe|context|it|should)'
      let regex = '\v^\s*%(describe|context|it|should) (%("|'')?)\zs.+\ze\1'
    else
      let regex = '\v^\s*%(def \zstest_\w+|test ("|'')\zs.+\ze\1|class \zs\S+)'
    endif

    if !empty(matchstr(line, regex))
      return matchstr(line, regex)
    endif
  endfor
endfunction
