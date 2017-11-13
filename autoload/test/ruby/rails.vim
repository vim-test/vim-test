if !exists('g:test#ruby#rails#file_pattern')
  let g:test#ruby#rails#file_pattern = '\v_test\.rb$'
endif

function! test#ruby#rails#test_file(file) abort
  if empty(s:rails_version()) || s:rails_version()[0] < 5
    return 0
  end

  return a:file =~# g:test#ruby#rails#file_pattern
endfunction

function! test#ruby#rails#build_position(type, position) abort
  if a:type ==# 'nearest'
    return [a:position['file'].':'.a:position['line']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#ruby#rails#build_args(args) abort
  return a:args
endfunction

function! test#ruby#rails#executable() abort
  if !empty(glob('.zeus.sock'))
    return 'zeus rails test'
  elseif filereadable('./bin/rails') && get(g:, 'test#ruby#use_binstubs', 1)
    return './bin/rails test'
  elseif filereadable('Gemfile') && get(g:, 'test#ruby#bundle_exec', 1)
    return 'bundle exec rails test'
  else
    return 'rails test'
  endif
endfunction

function! s:rails_version() abort
  if filereadable('Gemfile.lock')
    for line in readfile('Gemfile.lock')
      let version_string = matchstr(line, '\v^ *rails \(\zs\d+\.\d+\..+\ze\)')
      if version_string
        break
      endif
    endfor

    if version_string
      let rails_version = matchlist(version_string, '\v(\d+)\.(\d+)\.(\d+)%(\.(\d+))?')[1:-1]
      call filter(rails_version, '!empty(v:val)')
      call map(rails_version, 'str2nr(v:val)')

      return rails_version
    end
  endif
endfunction
