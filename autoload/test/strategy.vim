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
  execute 'AsyncRun -mode=term -pos=tab -focus=0 -listed=0 -post=echo\ eval("g:asyncrun_code\ ?\"Failure\":\"Success\"").":"'
          \ .'\ substitute(g:test\#strategy\#cmd,\ "\\",\ "",\ "") '.a:cmd
endfunction

function! test#strategy#dispatch(cmd) abort
  execute 'Dispatch '.a:cmd
endfunction

function! test#strategy#dispatch_background(cmd) abort
  execute 'Dispatch! '.a:cmd
endfunction

function! test#strategy#spawn(cmd) abort
  execute 'Spawn '.a:cmd
endfunction

function! test#strategy#spawn_background(cmd) abort
  execute 'Spawn! '.a:cmd
endfunction

function! test#strategy#vimproc(cmd) abort
  execute 'VimProcBang '.a:cmd
endfunction

function! s:neovim_new_term(cmd) abort
  let term_position = get(g:, 'test#neovim#term_position', 'botright')
  execute term_position . ' new'
  call termopen(a:cmd)
endfunction

function! s:neovim_reopen_term(bufnr) abort
  let l:current_window = win_getid()
  let term_position = get(g:, 'test#neovim#term_position', 'botright')
  execute term_position . ' new'
  " we need to unload the no name buffer we just created
  let l:current_buffer = bufnr("%")
  execute 'buffer ' . a:bufnr . ' | bunload ' . l:current_buffer

  let l:new_window = win_getid()
  call win_gotoid(l:current_window)
  return l:new_window
endfunction

function! test#strategy#neovim(cmd) abort
  call s:neovim_new_term(a:cmd)
  au BufDelete <buffer> wincmd p " switch back to last window
  if !get(g:, 'test#neovim#start_normal', 0)
    startinsert
  endif
endfunction

function! test#strategy#neovim_sticky(cmd) abort
  let l:cmd = [a:cmd, '']
  let l:tag = '_test_vim_neovim_sticky'
  let l:buffers = getbufinfo({ 'buflisted': 1 })
    \ ->filter({i, v -> has_key(v.variables, l:tag)})

  if !len(l:buffers) && get(g:, 'test#neovim_sticky#use_existing', 0)
    let l:buffers = getbufinfo({ 'buflisted': 1 })
      \ ->filter({i, v -> has_key(v.variables, 'terminal_job_id')})
  end

  if len(l:buffers) == 0
    let l:current_window = win_getid()
    call s:neovim_new_term(&shell)
    let l:buffers = getbufinfo(bufnr())
    call win_gotoid(l:current_window)
  else
    if !get(g:, 'test#preserve_screen', 1)
      let l:cmd = [&shell == 'cmd.exe' ? 'cls': 'clear'] + l:cmd
    endif
    if get(g:, 'test#neovim_sticky#kill_previous', 0)
      let l:cmd = [""] + l:cmd
    endif
  endif
  call setbufvar(l:buffers[0].bufnr, l:tag, 1)

  let l:win = win_findbuf(l:buffers[0].bufnr)
  if !len(l:win) && get(g:, 'test#neovim_sticky#reopen_window', 0)
    let l:win = [s:neovim_reopen_term(l:buffers[0].bufnr)]
  endif

  " Needs explicit join to work in all shells
  call chansend(l:buffers[0].variables.terminal_job_id, join(l:cmd, "\r"))
  if len(l:win) > 0
    call win_execute(l:win[0], 'normal G', 1)
  endif
endfunction

function! test#strategy#neovim_vscode(cmd) abort
  " Remove any WSL distribution
  let l:clean_cmd = substitute(a:cmd, 'vscode-remote://wsl%2B[^/]*', '', 'g')
  " Focus terminal, run command and take the focus back to EditorGroup (buffer)
  call VSCodeNotify('workbench.action.terminal.focus')
  call VSCodeNotify('workbench.action.terminal.sendSequence', {'text': "clear\n"})
  call VSCodeNotify('workbench.action.terminal.sendSequence', {'text': l:clean_cmd . "\n"})
  call VSCodeNotify('workbench.action.focusActiveEditorGroup')
endfunction

function! test#strategy#vimterminal(cmd) abort
  let term_position = get(g:, 'test#vim#term_position', 'botright')
  execute term_position . ' new'
  call term_start(!s:Windows() ? ['/bin/sh', '-c', a:cmd] : ['cmd.exe', '/c', a:cmd], {'curwin': 1, 'term_name': a:cmd})
  au BufDelete <buffer> wincmd p " switch back to last window
  nnoremap <buffer> <Enter> :bd<CR>
  redraw
  echo "Press <Enter> to exit test runner terminal (<Ctrl-C> first if command is still running)"
endfunction

function! test#strategy#neoterm(cmd) abort
  call neoterm#do({ 'cmd': a:cmd})
endfunction

function! test#strategy#toggleterm(cmd) abort
  execute "TermExec cmd='".substitute(a:cmd, "'", '"', "g")."'"
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

  if exists('g:test#preserve_screen') && !g:test#preserve_screen
      call system("shtuff into " . shellescape(g:shtuff_receiver) . " " . shellescape("clear;" . a:cmd))
  else
      call system("shtuff into " . shellescape(g:shtuff_receiver) . " " . shellescape(a:cmd))
  endif
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

function! test#strategy#wezterm(cmd) abort
  let l:wezterm = get(g:, "test#wezterm#executable", "wezterm")

  if !exists("g:test#wezterm#pane_id")
    let l:output = systemlist([l:wezterm, "cli", "get-pane-direction", "next"])

    " wezterm outputs the current pane ID if only one pane is open
    if l:output[0] == $WEZTERM_PANE
      let l:prev = $WEZTERM_PANE
      let l:dir = get(g:, "test#wezterm#split_direction", "right")
      let l:width = get(g:, "test#wezterm#split_percent", 50)
      let l:output = systemlist([l:wezterm, "cli", "split-pane", "--percent", l:width, "--" . l:dir])

      " return to original pane
      call system([l:wezterm, "cli", "activate-pane", "--pane-id", l:prev])
    endif

    let g:test#wezterm#pane_id = l:output[0]
  endif

  call system([l:wezterm, "cli", "send-text", "--no-paste", "--pane-id", g:test#wezterm#pane_id, a:cmd . ""])
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
