#echo "bashrc loading..."
## Options I like
## See .inputrc for Readline options
set -o vi

# This allows you to bookmark your favorite places across the file system
# Define a variable containing a path and you will be able to cd into it regardless of the directory you're in
shopt -s cdable_vars

# Examples:
# export dotfiles="$HOME/dotfiles"
# export projects="$HOME/projects"
# export documents="$HOME/Documents"
# export dropbox="$HOME/Dropbox"

# Update window size after every command
shopt -s checkwinsize

# This makes writing to history happen after each prompt 
# So multiple logins are all sharing history
shopt -s histappend
PROMPT_COMMAND='history -a'

# Save multi-line commands as one command
shopt -s cmdhist

export HISTSIZE=500000
export HISTFILESIZE=100000
export HISTCONTROL="erasedups:ignoreboth"
export HISTIGNORE="&:[ ]*:exit:ls:[bf]g:history:clear:"
# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
HISTTIMEFORMAT='%F %T '

# Enable incremental history search with up/down arrows (also Readline goodness)
# Learn more about this here: http://codeinthehole.com/writing/the-most-important-command-line-tip-incremental-history-searching-with-inputrc/
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'

export TIMEFORMAT="%Rs - "
export IGNOREEOF=3
export FCEDIT=vim
export XML_CATALOG_FILES=/usr/local/etc/xml/catalog
export CLICOLOR=1
#export LSCOLORS=hxfxcxdxbxegedabagacad
# Testing a more solarized color scheme
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
export HOMEBREW_NO_GITHUB_API=1

## Shell color codes 
COLOR_WHITE='\033[1;37m'
COLOR_LIGHTGRAY='033[0;37m'
COLOR_GRAY='\033[1;30m'
COLOR_BLACK='\033[0;30m'
COLOR_RED='\033[0;31m'
COLOR_LIGHTRED='\033[1;31m'
COLOR_GREEN='\033[0;32m'
COLOR_LIGHTGREEN='\033[1;32m'
COLOR_BROWN='\033[0;33m'
COLOR_YELLOW='\033[1;33m'
COLOR_BLUE='\033[0;34m'
COLOR_LIGHTBLUE='\033[1;34m'
COLOR_PURPLE='\033[0;35m'
COLOR_PINK='\033[1;35m'
COLOR_CYAN='\033[0;36m'
COLOR_LIGHTCYAN='\033[1;36m'
COLOR_DEFAULT='\033[0m'


if [ -f /usr/local/bin/dircolors ]; then
        eval `/usr/local/bin/dircolors -c ~/.dircolors`;
fi

## BETTER DIRECTORY NAVIGATION ##

# Prepend cd to directory names automatically
shopt -s autocd 2> /dev/null
# Correct spelling errors during tab-completion
shopt -s dirspell 2> /dev/null
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null

# This defines where cd looks for targets
# Add the directories you want to have fast access to, separated by colon
# Ex: CDPATH=".:~:~/projects" will look for targets in the current working directory, in home and in the ~/projects folder
CDPATH=".:~:~/Library:~/Projects"	

## Old Prompt Prompt Shit
#Known good prompt :)
#export PS1="\[\033]0;\u@\h:\w\007\][\[\e[1m\]\h\[\e[0m\]]Aye, Cap'n? "

## Liquid Prompt if shell is interactive 
[[ $- = *i* ]] && source ~/bin/liquidprompt/liquidprompt

## Source Aliases
[ -f ~/.aliases ] && source ~/.aliases

## Source Functions
[ -f ~/.functions ] && source ~/.functions

## Source Terraform variables
include ~/.oci/env-vars

# Ruby Path
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
