if !exists('g:test#rust#cargotest#file_pattern')
  let g:test#rust#cargotest#file_pattern = '\v\.rs$'
endif

if !exists('g:test#rust#cargotest#test_patterns')
  let g:test#rust#cargotest#test_patterns = {
        \ 'test': ['\v(#\[%(tokio::|rs)?test)'],
        \ 'namespace': ['\vmod (tests?)']
    \ }
endif

if !exists('g:test#rust#cargotest#patterns')
  let g:test#rust#cargotest#patterns = {
        \ 'test': ['\v\s*%(async )?fn\s+(\w+)'],
        \ 'namespace': []
    \ }
endif

function! test#rust#cargotest#test_file(file) abort
  return a:file =~# g:test#rust#cargotest#file_pattern
endfunction

" This function fits libs unit testing
" Need to implement integration testing and bechmarks and examples
" TODO
function! test#rust#cargotest#build_position(type, position) abort
  " If running the whole suite, don't need to do anything
  if a:type !=# 'suite'
    " Else
    " We need the test module namespace
    let l:namespace = s:test_namespace(a:position['file'])
    let l:package = l:namespace[0]
    let l:namespace = l:namespace[1]

    if l:package != v:null
        let l:package = ['--package', l:package]
    else
        let l:package = []
    endif

    if a:type ==# 'nearest'
      let l:test_name = s:nearest_test(a:position)
      return l:package + [shellescape(l:namespace.l:test_name), "--", "--exact"]
    elseif a:type ==# 'file'
      " FIXME Should not run submodule tests
      return l:package + [shellescape(l:namespace)]
    endif
  endif

  return []
endfunction

function! test#rust#cargotest#build_args(args) abort
  return a:args
endfunction

function! test#rust#cargotest#executable() abort
  return 'cargo test'
endfunction

function! s:nearest_test(position) abort
  " Search backward for the first test pattern (usually '#[test]')
  let name = test#base#nearest_test(a:position, g:test#rust#cargotest#test_patterns)

  " If we didn't find the '#[test]' attribute, return empty
  if empty(name['test']) || name['test'][0] !~ '#\[.*'
    return ''
  endif

  " Else
  " Search forward for the first declared method
  let name_f = test#base#nearest_test_in_lines(
    \ a:position['file'],
    \ name['test_line'],
    \ a:position['line'],
    \ g:test#rust#cargotest#patterns
  \ )

  if len(name['namespace']) > 0
    return join([name['namespace'][0], name_f['test'][0]], '::')
  else
    return name_f['test'][0]
  endif
endfunction

function! s:test_namespace(filename) abort
  let l:path = fnamemodify(a:filename, ':r')
  " On a normal cargo project, the first item is 'src'
  let l:modules = split(l:path, '/')

  " 'src/main.rs', 'src/lib.rs' and 'src/some/mod.rs' do not end
  " with actual module names
  if l:modules[-1] =~# '\v^(main|lib|mod)$'
    let l:modules = l:modules[:-2]
  endif

  let l:package = v:null
  " Find package by searching upwards for Cargo.toml
  for idx in range(len(l:modules) - 2, 0, -1)
      let l:cargo_toml = join(l:modules[:idx] + ['Cargo.toml'], '/')
      if !empty(glob(cargo_toml))
          echo 
          let l:package = l:modules[idx]
          let l:modules = l:modules[idx+1:]
          break
      endif
  endfor

  " Build up tests module namespace
  if l:modules[0] == 'tests' && len(l:modules) == 2
    return [l:package, '']
  else
    let l:modules = l:modules[1:]
    if len(l:modules) > 0
      return [l:package, join(l:modules, '::') . '::']
    else
      return [l:package, '']
    endif
  endif
endfunction
