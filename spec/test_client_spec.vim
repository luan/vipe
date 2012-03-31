call writefile([''], 'fakepipe')

let g:dir = expand('<sfile>:p:h')
let g:spec_filename = [g:dir . '/example_spec.rb']
SpecBegin 'title': 'test client',
      \ 'sfile': g:dir . '/../plugin/test_client.vim',
      \ 'file': g:spec_filename,
      \ 'before': 'call RunTest()'

It should be able to run the whole test file.
Should be equal readfile('fakepipe'), g:spec_filename
