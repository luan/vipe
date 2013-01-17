if !exists("g:vipe_pipe")
  let g:vipe_pipe = $HOME . "/vipe_pipe"
endif

let s:command_stack = []

command! -nargs=? Vipe call Vipe(<q-args>)
command! VipePop call VipePop()

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
    call writefile([s:command_stack[0]], g:vipe_pipe)
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

