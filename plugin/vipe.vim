if !exists("g:vipe_pipe")
  let g:vipe_pipe = $HOME . "/vipe_pipe"
endif

command! -nargs=? Vipe call s:SendToPipe(<q-args>)

function! s:SendToPipe(...)
  if len(a:1) == 0
    call s:ResendToPipe()
    return
  end

  let command = join(a:000)
  call writefile([command], g:vipe_pipe)
  echom "Sent " . command
  let s:last_command = command
endf

function! s:ResendToPipe()
  if exists('s:last_command')
    call writefile([s:last_command], g:vipe_pipe)
    echom "Sent " . s:last_command
  else
    echom "No previous command ran"
  end
endf

