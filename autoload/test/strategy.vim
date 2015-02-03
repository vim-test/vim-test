function! test#strategy#vimscript(cmd) abort
  execute a:cmd.value
endfunction

function! test#strategy#basic(cmd) abort
  if s:restorescreen()
    execute '!'.s:pretty_command(a:cmd.value)
  else
    execute '!'.a:cmd.value
  endif
endfunction

function! test#strategy#dispatch(cmd) abort
  if !empty(a:cmd.compiler)
    call extend(g:dispatch_compilers, {a:cmd.executable: a:cmd.compiler})
  endif
  execute 'Dispatch '.a:cmd.value
endfunction

function! test#strategy#vimux(cmd) abort
  call VimuxRunCommand(s:pretty_command(a:cmd.value))
endfunction

function! test#strategy#tslime(cmd) abort
  call Send_to_Tmux(s:pretty_command(a:cmd.value)."\n")
endfunction

function! test#strategy#terminal(cmd) abort
  call s:execute_script('osx_terminal', s:pretty_command(a:cmd.value))
endfunction

function! test#strategy#iterm(cmd) abort
  call s:execute_script('osx_iterm', s:pretty_command(a:cmd.value))
endfunction

function! s:execute_script(name, cmd) abort
  let script_path = g:test#plugin_path . '/bin/' . a:name
  let cmd = join([script_path, shellescape(a:cmd)])
  execute 'silent !'.cmd
endfunction

function! s:pretty_command(cmd) abort
  let clear = !s:Windows() ? 'clear' : 'cls'
  let echo  = !s:Windows() ? 'echo -e '.shellescape(a:cmd) : 'Echo '.shellescape(a:cmd)

  return join([l:clear, l:echo, a:cmd], ' && ')
endfunction

function! s:Windows() abort
  return has('win32') && fnamemodify(&shell, ':t') ==? 'cmd.exe'
endfunction

function! s:restorescreen() abort
  if s:Windows()
    return &restorescreen
  else
    return !empty(&t_ti) || !empty(&t_te)
  endif
endfunction
