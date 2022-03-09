function! test#dart#test_file(runner, file_pattern, file) abort
  if fnamemodify(a:file, ':t') =~# a:file_pattern
    if exists('g:test#dart#runner')
      return a:runner == g:test#dart#runner
    endif

    let contains_flutter_test_import = (search('package:flutter_test/flutter_test.dart', 'n') > 0)

    if a:runner ==# 'fluttertest'
      return contains_flutter_test_import
    else
      return !contains_flutter_test_import
    endif
  endif
endfunction
