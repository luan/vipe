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

I recommend binding functions to keys, for example:

    map <F12> :w<CR>:RunTest<CR>
    imap <F12> <ESC><F12>
    map <F11> :w<CR>:RunTestLine<CR>
    imap <F11> <ESC><F11>
    map <F10> :w<CR>:RunTestAgain<CR>
    imap <F10> <ESC><F10>

In your ~/.vimrc will bind F12 to save-and-run-test, F11 to
save-and-run-line and F10 to run-previous-test-again.

## Further configuration

Say you wanted to add the ability to run JavaScript testing with
jasmine-headless-webkit. You'd want to add a new test command for a test type:

    :let g:testcmdfortesttypes.jasmine = 'jasmine-headless-webkit'
    
(assuming you have a 'jasmine' test type: see example for rspec at top of
test_client.vim)

If you also wanted to run tests from an associated source file, and if your
source JavaScript files were in public/javascripts, you'd do:

    :let g:testcmdforsrctypes.javascript = 'jasmine-headless-webkit'
    :call add(g:nontestfilereplacements, ['public/javascripts/', 'spec/javascripts/'])

The second line is only necessary if your JavaScript files aren't in
app/javascripts.

For the above differential technique, make sure you change the globals after
the plugin has been loaded.

Alternatively, exhaustively set these globals before the plugin is loaded, or
crack open the test_client.vim file and edit the globals to taste.
