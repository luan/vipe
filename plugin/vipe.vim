let s:command_stack = []

command! -nargs=? Vipe call vipe#push(<q-args>)
command! VipePop call vipe#pop()

function! vipe#pipe_path()
  return "/tmp/.vipe_pipe_" .  substitute(getcwd(), '/', '_', 'g')
endf

function! vipe#push(...)
  if len(a:1) == 0
    call vipe#rerun()
    return
  end

  let l:command = join(a:000)
  if len(s:command_stack) == 0 || s:command_stack[0] != l:command
    call insert(s:command_stack, command)
  end
  call vipe#rerun()
endf

function! vipe#run(command)
  call writefile([a:command], vipe#pipe_path())
  echom "[vipe] running command: " . a:command
endf

function! vipe#rerun()
  if len(s:command_stack) > 0
    call vipe#run(s:command_stack[0])
  else
    echom "[vipe] no commands in stack"
  end
endf

function! vipe#pop()
  if len(s:command_stack) > 0
    call remove(s:command_stack, 0)
  end
  call vipe#rerun()
endf

