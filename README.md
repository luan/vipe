# Test Server

This was borne out of frustration with the current state of DRB, autospec / test
/ rspactor et al. They were just taking too long to set up for me.

Maybe someone else can use this as a base for their own particular solution. You
can use this approach to do anything you like with the file you're currently
editing, or anything you like with whatever you throw at the named pipe.

## Installation

* Install into your ~/.vim/bundle (assuming you use Pathogen)
* Run test_server.rb in a terminal
* Fire up Vim and open a spec or feature file.
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

