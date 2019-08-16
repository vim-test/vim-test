if !exists('g:test#go#delve#file_pattern')
  let g:test#go#delve#file_pattern = g:test#go#gotest#file_pattern
endif

function! test#go#delve#test_file(file) abort
  return test#go#test_file('delve', g:test#go#delve#file_pattern, a:file)
endfunction

function! test#go#delve#build_position(type, position) abort
  if a:type ==# 'suite'
    return ['./...']
  else
    let path = './'.fnamemodify(a:position['file'], ':h')

    if a:type ==# 'file'
      return path ==# './.' ? [] : [path . '/...']
    elseif a:type ==# 'nearest'
      let name = s:nearest_test(a:position)
      return empty(name) ? [] : [path, '--', '-test.run '.shellescape(name.'$', 1)]
    endif
  endif
endfunction

function! test#go#delve#build_options(args, options) abort
  let args = a:args
  if len(a:options) > 0 && index(args, '--') == -1
    let args = args + ['--']
  endif
  return args + a:options
endfunction

function! test#go#delve#build_args(args) abort
  let args = a:args

  " Optionally, if the vim-delve plugin is installed this will also include
  " any breakpoints, tracepoints, etc that have been marked in vim into the
  " state of delve when it runs.
  if exists('*delve#getInitInstructions')
    let delve_init_instructions = delve#getInitInstructions()
    if len(delve_init_instructions) > 0
      let temp_file = tempname()
      call writefile(delve_init_instructions, temp_file)
      let args = ['--init='.temp_file] + a:args
    endif
  endif

  return args
endfunction

function! test#go#delve#executable() abort
  return 'dlv test'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#go#patterns)
  return join(name['test'])
endfunction
