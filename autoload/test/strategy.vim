function! test#strategy#vimscript(cmd) abort
  execute a:cmd
endfunction

function! test#strategy#basic(cmd) abort
  if s:restorescreen()
    execute '!'.s:pretty_command(a:cmd)
  else
    execute '!'.a:cmd
  endif
endfunction

function! test#strategy#make(cmd) abort
  let compiler = dispatch#compiler_for_program(a:cmd)

  try
    let default_makeprg = &l:makeprg
    let default_errorformat = &l:errorformat
    let default_compiler = get(b:, 'current_compiler', '')

    if !empty(compiler)
      execute 'compiler ' . compiler
    endif
    if s:restorescreen()
      let &l:makeprg = s:pretty_command(a:cmd)
    else
      let &l:makeprg = a:cmd
    endif
    make
  finally
    let &l:makeprg = default_makeprg
    let &l:errorformat = default_errorformat
    if empty(default_compiler)
      unlet! b:current_compiler
    else
      let b:current_compiler = default_compiler
    endif
  endtry
endfunction

function! test#strategy#dispatch(cmd) abort
  execute 'Dispatch '.a:cmd
endfunction

function! test#strategy#vimproc(cmd) abort
  execute 'VimProcBang '.a:cmd
endfunction

function! test#strategy#neovim(cmd) abort
  let opts = {'suffix': ' # vim-test'}
  function! opts.close_terminal()
    if bufnr(self.suffix) != -1
      execute 'bdelete!' bufnr(self.suffix)
    end
  endfunction
  call opts.close_terminal()

  botright new
  call termopen(a:cmd . opts.suffix, opts)
  au BufDelete <buffer> wincmd p
  startinsert
endfunction

function! test#strategy#neoterm(cmd) abort
  call neoterm#do(a:cmd)
endfunction

function! test#strategy#vtr(cmd) abort
  call VtrSendCommand(s:pretty_command(a:cmd), 1)
endfunction

function! test#strategy#vimux(cmd) abort
  if exists('g:test#preserve_screen') && !g:test#preserve_screen
    if exists("g:VimuxRunnerIndex") && _VimuxHasRunner(g:VimuxRunnerIndex) != -1
      call VimuxRunCommand(!s:Windows() ? 'clear' : 'cls')
      call VimuxClearRunnerHistory()
    endif
    call VimuxRunCommand(s:command(a:cmd))
  else
    call VimuxRunCommand(s:pretty_command(a:cmd))
  endif
endfunction

function! test#strategy#tslime(cmd) abort
  call Send_to_Tmux(s:pretty_command(a:cmd)."\n")
endfunction

function! test#strategy#vimshell(cmd) abort
  execute 'VimShellExecute '.a:cmd
endfunction

function! test#strategy#terminal(cmd) abort
  call s:execute_script('osx_terminal', s:pretty_command(a:cmd))
endfunction

function! test#strategy#iterm(cmd) abort
  call s:execute_script('osx_iterm', s:pretty_command(a:cmd))
endfunction

function! s:execute_script(name, cmd) abort
  let script_path = g:test#plugin_path . '/bin/' . a:name
  let cmd = join([script_path, shellescape(a:cmd)])
  execute 'silent !'.cmd
endfunction

function! s:pretty_command(cmd) abort
  let clear = !s:Windows() ? 'clear' : 'cls'
  let cd = 'cd ' . shellescape(getcwd())
  let echo  = !s:Windows() ? 'echo -e '.shellescape(a:cmd) : 'Echo '.shellescape(a:cmd)
  let separator = !s:Windows() ? '; ' : ' & '

  if !get(g:, 'test#preserve_screen')
    return join([l:clear, l:cd, l:echo, a:cmd], l:separator)
  else
    return join([l:cd, l:echo, a:cmd], l:separator)
  endif
endfunction

function! s:command(cmd) abort
  let cd = 'cd ' . shellescape(getcwd())
  let separator = !s:Windows() ? '; ' : ' & '

  return join([l:cd, a:cmd], l:separator)
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

function! s:cat(filename) abort
  if s:Windows()
    return system('type '.a:filename)
  else
    return system('cat '.a:filename)
  endif
endfunction
