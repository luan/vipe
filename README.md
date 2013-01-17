# Vipe

This is a fork of [test_server](https://github.com/camelpunch/test_server).
I removed the test runner functionality and turned it into a simple command
pipe with a stack.

## Installation

* Install into your ~/.vim/bundle (assuming you use Pathogen)
* Run vipe in a terminal
* Fire up Vim and open a model, controller, spec or feature file.
* Type ':Vipe <command>' to run a command, ':Vipe' to re-run the last or
':VipePop' to pop the stack and run the previous command

I recommend this to run tests.

