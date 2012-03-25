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
* Type ':call RunTest()' or ':call RunTestLine()' for example under line
* ???
* Eat flapjacks

I recommend binding functions to keys, for example:

    map <F12> :w<CR>:call RunTest()<CR>
    imap <F12> <ESC><F12>
    map <F11> :w<CR>:call RunTestLine()<CR>
    imap <F11> <ESC><F11>

In your ~/.vimrc will bind F12 to save-and-run-test and F11 to
save-and-run-line

## Further configuration

Say you wanted to add the ability to run JavaScript testing with
jasmine-headless-webkit. You'd want to add a new test command for a test type:

:let g:testcmdfortesttypes.javascript = 'jasmine-headless-webkit'

If you also wanted to run tests from an associated source file, and if your
source JavaScript files were in public/javascripts, you'd do:

:let g:testcmdforsrctypes.javascript = 'jasmine-headless-webkit'
:call add(g:nontestfilereplacements, ['public/javascripts/', 'spec/javascripts/'])

The second line is only necessary if your JavaScript files aren't in
app/javascripts.

Make sure you change the globals after the plugin has been loaded.
Alternatively, crack open the test_client.vim file and edit the globals to
taste.
