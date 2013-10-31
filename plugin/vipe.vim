let s:command_stack = []

command! -nargs=? Vipe call Vipe(<q-args>)
command! VipePop call VipePop()

function! VipePipePath()
  if !exists("g:vipe_pipe")
    let pipe_path = $HOME . "/.vipe_pipe_" .  substitute(getcwd(), '/', '_', 'g')
  else
    let pipe_path = g:vipe_pipe
  endif

  return pipe_path
endfunction

function! Vipe(...)
  if len(a:1) == 0
    call VipeRerun()
    return
  end

  let command = join(a:000)
  if len(s:command_stack) == 0 || s:command_stack[0] != command
    call insert(s:command_stack, command)
  end
  call VipeRerun()
endf

function! VipeRerun()
  if len(s:command_stack) > 0
    call writefile([s:command_stack[0]], VipePipePath())
    echom "Sent " . s:command_stack[0]
  else
    echom "No previous command ran"
  end
endf

function! VipePop()
  if len(s:command_stack) > 0
    call remove(s:command_stack, 0)
  end
  call VipeRerun()
endf

