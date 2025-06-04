if !exists('g:test#cpp#catch2#file_pattern')
  let g:test#cpp#catch2#file_pattern = '\v[tT]est.*(\.cpp)$'
endif

if !exists('g:test#cpp#catch2#test_patterns')
  let g:test#cpp#catch2#test_patterns = {
        \ 'test': ['\vTEST_CASE\(\s*"([^"]*)"', '\vTEST_CASE_METHOD\(.{-},\s*"([^"]*)"'],
        \ 'namespace': []
    \ }
endif

if !exists('g:test#cpp#catch2#relToProject_build_dir')
    let g:test#cpp#catch2#relToProject_build_dir = "build"
endif

if !exists('g:test#cpp#catch2#bin_dir')
    let g:test#cpp#catch2#bin_dir = "./"
endif

if !exists('g:test#cpp#catch2#make_command')
    let nproc = trim(system("nproc"))
    let g:test#cpp#catch2#make_command = "make -j" . nproc
endif

if !exists('g:test#cpp#catch2#suite_command')
    let nproc = trim(system("nproc"))
    let g:test#cpp#catch2#suite_command = "ctest --output-on-failure -j" . nproc
endif


let s:is_suite = v:false

" Returns true if the given file belongs to your test runner
function! test#cpp#catch2#test_file(file)
  return a:file =~# g:test#cpp#catch2#file_pattern
endfunction

" Returns test runner's arguments(as a list) which will run the current file and/or line
" position: a dictionary with the file, line and col
function! test#cpp#catch2#build_position(type, position)
    if a:type ==# 'nearest'
        let name = s:nearest_test(a:position)
        return map(name,'shellescape(v:val)') "Since name may have spaces in it
    elseif a:type ==# 'file'
        return []
    elseif a:type ==# 'suite'
        let s:is_suite = v:true
        return []
    endif
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#cpp#catch2#test_patterns)

  if empty(name['test'])
      " Search forward for the first declared method
      let f_name = test#base#nearest_test_in_lines(
                  \ a:position['file'],
                  \ a:position['line'],
                  \ "$",
                  \ g:test#cpp#catch2#test_patterns
                  \ )
      return f_name['test']
  endif
  return name['test']
endfunction


" Returns processed args (if you need to do any processing)
function! test#cpp#catch2#build_args(args)
  return a:args
endfunction

" Returns the executable of your test runner
function! test#cpp#catch2#executable()
    " Take advantage of the fact this will get called after test#cpp#catch2#build_position
    if s:is_suite
        let s:is_suite = v:false
        return "cd " . getcwd()
                    \ . " && cd " . g:test#cpp#catch2#relToProject_build_dir. " && "
                    \ . g:test#cpp#catch2#suite_command 
    else
        if !exists('g:test#cpp#catch2#test_target')
            let g:test#cpp#catch2#test_target = expand("%:t:r")
        endif
        return "cd " . getcwd()
                    \ . " && cd " . g:test#cpp#catch2#relToProject_build_dir  
                    \ . " && " . g:test#cpp#catch2#make_command  . " " . g:test#cpp#catch2#test_target
                    \ . " && cd " . g:test#cpp#catch2#bin_dir  
                    \ . " && ./" . g:test#cpp#catch2#test_target
    endif
endfunction
