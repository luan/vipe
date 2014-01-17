let s:command_stack = []

command! -nargs=? Vipe call vipe#push(<q-args>)
command! VipePop call vipe#pop()

function! vipe#pipe_path()
  return "/tmp/.vipe_pipe_" .  substitute(getcwd(), '/', '_', 'g')
endf

function! vipe#raw_pop()
  if len(s:command_stack) > 0
    return remove(s:command_stack, 0)
  end
endf

function vipe#raw_push(command)
  if vipe#raw_peek() == 0 || vipe#raw_peek() != a:command
   call insert(s:command_stack, a:command)
  end
endf

function! vipe#raw_peek()
  if len(s:command_stack) > 0
    return s:command_stack[0]
  else
    return 0
  endif
endf

function! vipe#push(...)
  if len(a:1) == 0
    call vipe#peek()
    return
  end

  call vipe#raw_push(join(a:000))
  call vipe#peek()
endf

function! vipe#pop()
  call vipe#raw_pop()
  call vipe#peek()
endf

function! vipe#peek()
  let command = vipe#raw_peek()
  if string(command) == '0'
    echom "[vipe] no commands in stack"
  else
    call vipe#run(command)
  end
endf

function! vipe#run(command)
  call writefile([a:command], vipe#pipe_path())
  echom "[vipe] running command: " . a:command
endf

