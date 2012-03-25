au BufRead,BufNewFile *_spec.rb set filetype=rspec
au BufRead,BufNewFile *_spec.rb set syntax=ruby

if !exists("g:testserverpipe")
  let g:testserverpipe = $HOME . "/test_server_pipe"
endif

if !exists("g:testcmdfortesttypes")
  let g:testcmdfortesttypes = {
        \ 'rspec': 'bundle exec rspec',
        \ 'cucumber': 'bundle exec cucumber',
        \}
endif

if !exists("g:testcmdforsrctypes")
  let g:testcmdforsrctypes = {
        \ 'ruby': 'bundle exec rspec',
        \}
endif

let g:nontestfilenamereplacements = [
      \ ['lib/', 'spec/lib/'],
      \ ['app/', 'spec/'],
      \ ['.rb', '_spec.rb']
      \]

function! RunTest()
  call s:SendToTestServer(s:AppropriateTestFilename())
endfunction

function! RunTestLine()
  if s:InTestFile()
    call s:SendToTestServer(s:AppropriateTestFilename() . ':' . line('.'))
  else
    echom "Focused test doesn't make sense (not in a test)."
  endif
endfunction

function! s:AppropriateTestFilename()
  let l:filename = expand('%')

  if s:InTestFile()
    return g:testcmdfortesttypes[&ft] . ' ' . l:filename
  else
    return g:testcmdforsrctypes[&ft] . ' ' . s:AssociatedTestFilename(l:filename)
  endif
endfunction

function! s:SendToTestServer(command)
  call writefile([a:command], g:testserverpipe)
  echom "Sent " . a:command
endfunction

function! s:InTestFile()
  return has_key(g:testcmdfortesttypes, &ft)
endfunction

function! s:AssociatedTestFilename(srcfilename)
  return s:MultiSubString(a:srcfilename, g:nontestfilenamereplacements)
endfunction

function! s:MultiSubString(string, substitutions)
  let l:substituted = substitute(a:string, a:substitutions[0][0], a:substitutions[0][1], '')

  if len(a:substitutions) == 1
    return l:substituted
  else
    return s:MultiSubString(l:substituted, a:substitutions[1:-1])
  endif
endfunction

