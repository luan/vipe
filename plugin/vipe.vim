if !exists("g:vipe_pipe")
  let g:vipe_pipe = $HOME . "/vipe_pipe"
endif

let s:command_stack = []

command! -nargs=? Vipe call s:SendToPipe(<q-args>)
command! VipePop call s:PopAndSend()

function! s:SendToPipe(...)
  if len(a:1) == 0
    call s:ResendToPipe()
    return
  end

  let command = join(a:000)
  if len(s:command_stack) == 0 || s:command_stack[0] != command
    call insert(s:command_stack, command)
  end
  call s:ResendToPipe()
endf

function! s:ResendToPipe()
  if len(s:command_stack) > 0
    call writefile([s:command_stack[0]], g:vipe_pipe)
    echom "Sent " . s:command_stack[0]
  else
    echom "No previous command ran"
  end
endf

function! s:PopAndSend()
  if len(s:command_stack) > 0
    call remove(s:command_stack, 0)
  end
  call s:ResendToPipe()
endf

