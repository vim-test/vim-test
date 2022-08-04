function! test#strategy#vimscript(cmd) abort
  execute a:cmd
endfunction

function! test#strategy#basic(cmd) abort
  if has('nvim')
    -tabnew
    call termopen(a:cmd)
    if !get(g:, 'test#basic#start_normal', 0)
      startinsert
    endif
  else
    if s:restorescreen()
      execute '!'.s:pretty_command(a:cmd)
    else
      execute '!'.a:cmd
    endif
  end
endfunction

function! test#strategy#make(cmd) abort
  call s:execute_with_compiler(a:cmd, 'make')
endfunction

function! test#strategy#make_bang(cmd) abort
  call s:execute_with_compiler(a:cmd, 'make!')
endfunction

function! test#strategy#neomake(cmd) abort
  call s:execute_with_compiler(a:cmd, 'NeomakeProject')
endfunction

function! test#strategy#makegreen(cmd) abort
  call s:execute_with_compiler(a:cmd, 'MakeGreen')
endfunction

function! test#strategy#asyncrun(cmd) abort
  execute 'AsyncRun '.a:cmd
endfunction

function! test#strategy#asyncrun_setup_unlet_global_autocmd() abort
  if !exists('#asyncrun_background#User#AsynRunStop')
    augroup asyncrun_background
      autocmd!
      autocmd User AsyncRunStop if exists('g:test#strategy#cmd') | unlet g:test#strategy#cmd | endif
    augroup END
  endif
endfunction

function! test#strategy#asyncrun_background(cmd) abort
  let g:test#strategy#cmd = a:cmd
  call test#strategy#asyncrun_setup_unlet_global_autocmd()
  execute 'AsyncRun -mode=async -silent -post=echo\ eval("g:asyncrun_code\ ?\"Failure\":\"Success\"").":"'
          \ .'\ substitute(g:test\#strategy\#cmd,\ "\\",\ "",\ "") '.a:cmd
endfunction

function! test#strategy#asyncrun_background_term(cmd) abort
  let g:test#strategy#cmd = a:cmd
  call test#strategy#asyncrun_setup_unlet_global_autocmd()
  execute 'AsyncRun -mode=term -pos=tab -focus=0 -post=echo\ eval("g:asyncrun_code\ ?\"Failure\":\"Success\"").":"'
          \ .'\ substitute(g:test\#strategy\#cmd,\ "\\",\ "",\ "") '.a:cmd
endfunction

function! test#strategy#dispatch(cmd) abort
  execute 'Dispatch '.a:cmd
endfunction

function! test#strategy#dispatch_background(cmd) abort
  execute 'Dispatch! '.a:cmd
endfunction

function! test#strategy#vimproc(cmd) abort
  execute 'VimProcBang '.a:cmd
endfunction

function! test#strategy#neovim(cmd) abort
  let term_position = get(g:, 'test#neovim#term_position', 'botright')
  execute term_position . ' new'
  call termopen(a:cmd)
  au BufDelete <buffer> wincmd p " switch back to last window
  if !get(g:, 'test#neovim#start_normal', 0)
    startinsert
  endif
endfunction

function! test#strategy#vimterminal(cmd) abort
  let term_position = get(g:, 'test#vim#term_position', 'botright')
  execute term_position . ' new'
  call term_start(!s:Windows() ? ['/bin/sh', '-c', a:cmd] : ['cmd.exe', '/c', a:cmd], {'curwin': 1, 'term_name': a:cmd})
  au BufLeave <buffer> wincmd p
  nnoremap <buffer> <Enter> :q<CR>
  redraw
  echo "Press <Enter> to exit test runner terminal (<Ctrl-C> first if command is still running)"
endfunction

function! test#strategy#neoterm(cmd) abort
  call neoterm#do({ 'cmd': a:cmd})
endfunction

function! test#strategy#floaterm(cmd) abort
  execute 'FloatermNew --autoclose=0 '.a:cmd
endfunction

function! test#strategy#vtr(cmd) abort
  call VtrSendCommand(s:pretty_command(a:cmd), 1)
endfunction

function! test#strategy#vimux(cmd) abort
  if exists('g:test#preserve_screen') && !g:test#preserve_screen
    call VimuxClearTerminalScreen()
    call VimuxClearRunnerHistory()
    call VimuxRunCommand(s:command(a:cmd))
  else
    call VimuxRunCommand(s:pretty_command(a:cmd))
  endif
endfunction

function! test#strategy#tslime(cmd) abort
  call Send_to_Tmux(s:pretty_command(a:cmd)."\n")
endfunction

function! test#strategy#slimux(cmd) abort
  if exists('g:test#preserve_screen') && !g:test#preserve_screen
    call SlimuxSendCommand(s:pretty_command(a:cmd))
  else
    call SlimuxSendCommand(s:command(a:cmd))
  endif
endfunction

function! test#strategy#tmuxify(cmd) abort
  call tmuxify#pane_send_raw('C-u', '!')
  call tmuxify#pane_send_raw('q', '!')
  call tmuxify#pane_send_raw('C-u', '!')

  if exists('g:test#preserve_screen') && !g:test#preserve_screen
    call tmuxify#pane_send_raw('C-u', '!')
    call tmuxify#pane_send_raw('C-l', '!')
    call tmuxify#pane_send_raw('C-u', '!')
  endif

  call tmuxify#pane_run('!', s:command(a:cmd))
endfunction

function! test#strategy#vimshell(cmd) abort
  execute 'VimShellExecute '.a:cmd
endfunction

function! test#strategy#terminal(cmd) abort
  let cmd = join(['cd ' . shellescape(getcwd()), s:pretty_command(a:cmd)], '; ')
  call s:execute_script('osx_terminal', cmd)
endfunction

function! test#strategy#iterm(cmd) abort
  let cmd = join(['cd ' . shellescape(getcwd()), s:pretty_command(a:cmd)], '; ')
  call s:execute_script('osx_iterm', cmd)
endfunction

function! test#strategy#kitty(cmd) abort
  let cmd = join(['cd ' . shellescape(getcwd()), s:pretty_command(a:cmd)], '; ')
  call s:execute_script('kitty_runner', cmd)
endfunction

function! test#strategy#shtuff(cmd) abort
  if !exists('g:shtuff_receiver')
    echoerr 'You must define g:shtuff_receiver to use this strategy'
    return
  endif

  call system("shtuff into " . shellescape(g:shtuff_receiver) . " " . shellescape("clear;" . a:cmd))
endfunction

function! test#strategy#harpoon(cmd) abort
  let g:cmd = a:cmd . "\n"
  let l:harpoon_term = exists("g:test#harpoon_term") ? g:test#harpoon_term : 1
  lua require("harpoon.term").sendCommand(vim.api.nvim_eval("l:harpoon_term"), vim.g.cmd)
  let goToTerminal = exists("g:test#harpoon#gototerminal") ? g:test#harpoon#gototerminal : 1
  if goToTerminal
    lua require("harpoon.term").gotoTerminal(vim.api.nvim_eval("l:harpoon_term"))
  endif
endfunction

function! s:execute_with_compiler(cmd, script) abort
  try
    let default_makeprg = &l:makeprg
    let default_errorformat = &l:errorformat
    let default_compiler = get(b:, 'current_compiler', '')

    if exists(':Dispatch')
      let compiler = dispatch#compiler_for_program(a:cmd)
      if !empty(compiler)
        execute 'compiler ' . compiler
      endif
    endif

    let &l:makeprg = a:cmd

    execute a:script
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

function! s:execute_script(name, cmd) abort
  let script_path = g:test#plugin_path . '/bin/' . a:name
  let cmd = join([shellescape(script_path), shellescape(a:cmd)])
  execute 'silent !'.cmd
endfunction

function! s:pretty_command(cmd) abort
  let cmds = []
  let separator = !s:Windows() ? '; ' : ' & '

  if !get(g:, 'test#preserve_screen')
    call add(l:cmds, !s:Windows() ? 'clear' : 'cls')
  endif

  if get(g:, 'test#echo_command', 1)
    call add(l:cmds, !s:Windows() ? 'echo -e '.shellescape(a:cmd) : 'Echo '.shellescape(a:cmd))
  endif

  call add(l:cmds, a:cmd)

  return join(l:cmds, l:separator)
endfunction

function! s:command(cmd) abort
  let separator = !s:Windows() ? '; ' : ' & '

  return join([a:cmd], l:separator)
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
