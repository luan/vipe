# Test Server

This was borne out of frustration with the current state of DRB, autospec / test
/ rspactor et al. They were just taking too long to set up for me.

Maybe someone else can use this as a base for their own particular solution. You
can use this approach to do anything you like with the file you're currently
editing, or anything you like with whatever you throw at the named pipe.

## Installation

* Install into your ~/.vim/bundle (assuming you use Pathogen)
* Run test_server.rb in a terminal
* Fire up Vim and open a model, controller, spec or feature file.
* Type ':RunTest' or ':RunTestLine' for example under line, ':RunTestAgain' for previous run
* See your test run in the console you ran the server in
* ???
* Eat flapjacks

I recommend binding commands to keys, for example:

    map <F12> :w<CR>:RunTest<CR>
    imap <F12> <ESC><F12>
    map <F11> :w<CR>:RunTestLine<CR>
    imap <F11> <ESC><F11>
    map <F10> :w<CR>:RunTestAgain<CR>
    imap <F10> <ESC><F10>
    map <F9> :w<CR>:RunTestPrevious<CR>
    imap <F9> <ESC><F9>

In your ~/.vimrc will bind F12 to save-and-run-test, F11 to
save-and-run-line, F10 to save-and-run-test-again and F9 to save-and-run-previous-test.

## Further configuration

Say you wanted to add the ability to run JavaScript testing with
jasmine-headless-webkit. You'd want to add a new test command for a test type:

    :let g:test_cmd_for_test_pattern['.js$'] = 'jasmine-headless-webkit'

If you also wanted to run tests from an associated source file, and if your
source JavaScript files were in public/javascripts, you'd do:

    :let g:test_cmd_for_src_types['.js$'] = 'jasmine-headless-webkit'
    :call add(g:non_test_file_replacements, ['app/assets/javascripts/', 'spec/javascripts/'])

Alternatively, exhaustively set these globals before the plugin is loaded, or
crack open the test_client.vim file and edit the globals to taste.
