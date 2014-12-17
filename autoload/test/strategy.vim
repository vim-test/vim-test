function! test#strategy#basic(cmd, ...) abort
  execute '!'.s:pretty_command(a:cmd)
endfunction

function! test#strategy#dispatch(cmd, compiler) abort
  let old_compiler    = get(b:, 'current_compiler', '')
  let old_makeprg     = &l:makeprg
  let old_errorformat = &l:errorformat

  if !empty(a:compiler)
    let compiler = a:compiler
  else
    let compiler = s:last_compiler
  endif

  try | execute 'compiler '.compiler | catch 'E666' | endtry
  let &l:makeprg = s:pretty_command(a:cmd)

  Make

  let &l:errorformat     = old_errorformat
  let &l:makeprg         = old_makeprg
  let b:current_compiler = old_compiler
  if empty(old_compiler)
    unlet b:current_compiler
  endif

  let s:last_compiler = compiler
endfunction

function! test#strategy#vimux(cmd, ...) abort
  call VimuxRunCommand(s:pretty_command(a:cmd))
endfunction

function! test#strategy#tslime(cmd, ...) abort
  call Send_to_Tmux(s:pretty_command(a:cmd)."\n")
endfunction

function! test#strategy#terminal(cmd, ...) abort
  call s:execute_script('osx_terminal', s:pretty_command(a:cmd))
endfunction

function! test#strategy#iterm(cmd, ...) abort
  call s:execute_script('osx_iterm', s:pretty_command(a:cmd))
endfunction

function! s:execute_script(name, cmd) abort
  let script_path = g:test#plugin_path . '/bin/' . a:name
  let cmd = join([script_path, shellescape(a:cmd)])
  execute 'silent !'.cmd
endfunction

function! s:pretty_command(cmd) abort
  let clear = !s:Windows() ? 'clear' : 'cls'
  let echo  = !s:Windows() ? 'echo -e '.shellescape(a:cmd).'\\n' : 'Echo '.shellescape(a:cmd)

  return join([l:clear, l:echo, a:cmd], ' && ')
endfunction

function! s:Windows() abort
  return has('win32') && fnamemodify(&shell, ':t') ==? 'cmd.exe'
endfunction
