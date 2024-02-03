#!/bin/zsh
# History settings
# HISTFILE=~/.zsh_history   # set by /etc/zshrc
HISTSIZE=500000
HISTFILESIZE=999999
SAVEHIST=$HISTSIZE
HISTORY_IGNORE='(history|ls|l|cd|cd ..|cd -|pwd|exit|date|*xyzzy*|* --help)'

## Mutually Exclusive, choose one
# setopt SHARE_HISTORY           # share history between different instances of the shell
# setopt INC_APPEND_HISTORY      # Write to the history file immediately, not when the shell exits.
setopt INC_APPEND_HISTORY_TIME # history entry is written out to the file after the command is finished, so that the time taken by the command is recorded correctly in the history file in EXTENDED_HISTORY format.


# History
# http://zsh.sourceforge.net/Doc/Release/Options.html#History
setopt append_history          # append to history file
setopt extended_history        # write the history file in the ':start:elapsed;command' format
unsetopt hist_beep             # don't beep when attempting to access a missing history entry
setopt hist_expire_dups_first  # expire a duplicate event first when trimming history
setopt hist_find_no_dups       # don't display a previously found event
setopt hist_ignore_all_dups    # delete an old recorded event if a new event is a duplicate
setopt hist_ignore_dups        # don't record an event that was just recorded again
setopt hist_ignore_space       # don't record an event starting with a space
setopt hist_no_store           # don't store history commands
setopt hist_reduce_blanks      # remove superfluous blanks from each command line being added to the history list
setopt hist_save_no_dups       # don't write a duplicate event to the history file
setopt hist_verify             # don't execute immediately upon history expansion
setopt inc_append_history      # write to the history file immediately, not when the shell exits
setopt interactive_comments    # allow #style comments to be added on commandline
setopt share_history           # don't share history between all sessions
