function! test#ruby#minitest#test_file(file) abort
  return a:file =~# '_test\.rb$'
endfunction

function! test#ruby#minitest#build_position(type, position) abort
  if a:type == 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return [a:position['file'], '--name', '/'.name.'/']
    else
      return [a:position['file']]
    endif
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#ruby#minitest#build_args(args) abort
  for idx in range(0, len(a:args) - 1)
    if test#base#file_exists(a:args[idx])
      let path = remove(a:args, idx) | break
    endif
  endfor

  if exists('path') && isdirectory(path)
    let path = fnamemodify(path, ':p:.') . '**/*_test.rb'
  elseif !exists('path')
    let path = 'test/**/*_test.rb'
  endif

  for option in ['--name', '--seed']
    let idx = index(a:args, option)
    if idx != -1
      let value = remove(a:args, idx + 1)
      let a:args[idx] = option.'='.shellescape(value, 1)
    endif
  endfor

  let kind = matchstr(test#ruby#minitest#executable(), 'ruby\|rake')
  return s:build_{kind}_args(get(l:, 'path'), a:args)
endfunction

function! s:build_rake_args(path, args) abort
  let cmd = []
  if !empty(a:path) | call add(cmd, 'TEST="'.escape(a:path, '"').'"') | endif
  if !empty(a:args) | call add(cmd, 'TESTOPTS="'.escape(join(a:args), '"').'"') | endif

  return cmd
endfunction

function! s:build_ruby_args(path, args) abort
  if a:path =~# '*'
    return ['-e '.shellescape('Dir["./'.a:path.'"].each &method(:require)')] + a:args
  else
    return [a:path] + a:args
  endif
endfunction

function! test#ruby#minitest#executable() abort
  if system('cat Rakefile') =~# 'Rake::TestTask' ||
   \ (exists('b:rails_root') || filereadable('./bin/rails'))
    if !empty(glob('.zeus.sock'))
      return 'zeus rake test'
    elseif filereadable('./bin/rake')
      return './bin/rake test'
    elseif filereadable('Gemfile')
      return 'bundle exec rake test'
    else
      return 'rake test'
    endif
  else
    if filereadable('Gemfile')
      return 'bundle exec ruby -I test'
    else
      return 'ruby -I test'
    endif
  endif
endfunction

" http://chriskottom.com/blog/2014/12/command-line-flags-for-minitest-in-the-raw/
function! s:nearest_test(position) abort
  let syntax = s:syntax(a:position['file'])
  let name = test#base#nearest_test(a:position, g:test#ruby#levels[syntax])

  let namespace = filter([join(name[0], '::')], '!empty(v:val)')
  if empty(name[1])
    let test = []
  else
    let test_name = name[1][0]
    if syntax == 'spec'
      let test = ['test_\d+_'.test_name]
    else
      if test_name !~# '^test_'
        let test_name = 'test_'.substitute(test_name, '\s\+', '_', 'g')
      endif
      let test = [test_name]
    endif
  endif

  return join(namespace + test, '#')
endfunction

function! s:syntax(file) abort
  if system('cat '.a:file) =~# '\v\A\s*(it)'
    return 'spec'
  else
    return 'unit'
  endif
endfunction
