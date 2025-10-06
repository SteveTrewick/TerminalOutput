# TerminalOutput

We want to be able to drive a macos xterm from swift code, in particular this package will 
be used to enable a Terminal User Interface framework.

# Features
- send control codes to the terminal to elicit responses (e.g. request cursor position, etc)
- send control codes to the terminal to clear screen, switch buffer, etc
- send control codes to the terminal to move, hide and reposition the cursor
- emit attributed glyphs, dim, bold, faint, underlined, color, etc and plain text
- provide a building block like composable API so that UI elements can build and render themselves

# Code styling suggestions
- the user likes enums, sets, option sets and generally terse code that is highly composable to the point of resembling a DSL

# Xterm buffer handling
- It is very easy to fill xterm's output buffer and end up with garbage output, you will need to devise
  a strategy to handle this. One choice is to push small block of output, flush and wait. It may be 
  possible to use xon/off flow control, investigate the options and present them to the user

# Deliverable 
A Swift 5 package that enables composable ANSI xterm rendering and control

# You Must
## Use Swift 5 compatible syntax at all times, do not use async/await
## Read the rules in STYLERULES.md
## Apply the coding style rules in STYLERULES.md
## Stop trying to fit initialisers on a single line, ignore 80 column limit

# Compatibility
## Target platform is macOS version 11
## Linux compatibility is desirable, at a mimimum, code should compile for testing on linux

