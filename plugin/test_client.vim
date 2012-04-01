au BufRead,BufNewFile *_spec.rb set filetype=rspec
au BufRead,BufNewFile *_spec.rb set syntax=ruby

if !exists("g:test_server_pipe")
  let g:test_server_pipe = $HOME . "/test_server_pipe"
endif

if !exists("g:test_cmd_for_test_types")
  let g:test_cmd_for_test_types = {
        \ 'rspec': 'bundle exec rspec',
        \ 'cucumber': 'bundle exec cucumber',
        \}
endif

if !exists("g:test_cmd_for_src_types")
  let g:test_cmd_for_src_types = {
        \ 'ruby': 'bundle exec rspec',
        \}
endif

let g:non_test_filename_replacements = [
      \ ['lib/', 'spec/lib/'],
      \ ['app/', 'spec/'],
      \ ['.rb', '_spec.rb']
      \]

command! RunTest call s:RunTest()
command! RunTestLine call s:RunTestLine()
command! RunTestAgain call s:RunTestAgain()

function! s:RunTest()
if s:TestIsExecutable()
  call s:SendToTestServer(s:AppropriateTestFilename())
endif
endf

function! s:RunTestLine()
if s:InTestFile()
  call s:SendToTestServer(s:AppropriateTestFilename() . ':' . line('.'))
else
  echom "Focused test doesn't make sense (not in a test)."
endif
endf

function! s:RunTestAgain()
if exists("s:last_test_run")
  call s:SendToTestServer(s:last_test_run)
else
  echom "No previous test run"
endif
endf

function! s:AppropriateTestFilename()
let l:filename = expand('%')

if s:InTestFile()
  return g:test_cmd_for_test_types[&ft] . ' ' . l:filename
else
  return g:test_cmd_for_src_types[&ft] . ' ' . s:AssociatedTestFilename(l:filename)
endif
endf

function! s:SendToTestServer(command)
call writefile([a:command], g:test_server_pipe)
echom "Sent " . a:command
let s:last_test_run = a:command
endf

function! s:InTestFile()
return has_key(g:test_cmd_for_test_types, &ft)
endf

function! s:InSrcFile()
return has_key(g:test_cmd_for_src_types, &ft)
endf

function! s:TestIsExecutable()
return s:InTestFile() || s:InSrcFile()
endf

function! s:AssociatedTestFilename(src_filename)
return s:MultiSubString(a:src_filename, g:non_test_filename_replacements)
endf

function! s:MultiSubString(string, substitutions)
let l:substituted = substitute(a:string, a:substitutions[0][0], a:substitutions[0][1], '')

if len(a:substitutions) == 1
  return l:substituted
else
  return s:MultiSubString(l:substituted, a:substitutions[1:-1])
endif
endf

