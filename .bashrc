echo "bashrc loading..."
#Shell Variables
HISTSIZE=500000
HISTFILESIZE=100000
HISTCONTROL="erasedups:ignoreboth"
HISTIGNORE="&:[ ]*:exit:ls:[bf]g:history:clear:"
# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
HISTTIMEFORMAT='%F %T '
export CLICOLOR=1
# Directorys Blue, Symlinks cyan
export LSCOLORS=exGxhxDxfxhxhxhxhxcxcx
# export LS_COLORS='di=34:ln=1;36:so=37:pi=1;33:ex=35:bd=37:cd=37:su=31:sg=31:tw=32:ow=32'
# ## Shell color codes
# COLOR_WHITE='\033[1;37m'
# COLOR_LIGHTGRAY='033[0;37m'
# COLOR_GRAY='\033[1;30m'
# COLOR_BLACK='\033[0;30m'
# COLOR_RED='\033[0;31m'
# COLOR_LIGHTRED='\033[1;31m'
# COLOR_GREEN='\033[0;32m'
# COLOR_LIGHTGREEN='\033[1;32m'
# COLOR_BROWN='\033[0;33m'
# COLOR_YELLOW='\033[1;33m'
# COLOR_BLUE='\033[0;34m'
# COLOR_LIGHTBLUE='\033[1;34m'
# COLOR_PURPLE='\033[0;35m'
# COLOR_PINK='\033[1;35m'
# COLOR_CYAN='\033[0;36m'
# COLOR_LIGHTCYAN='\033[1;36m'
# COLOR_DEFAULT='\033[0m'

# ENV variables
export TIMEFORMAT="%Rs - "
export IGNOREEOF=3
export FCEDIT=vim
export EDITOR=vim
export XML_CATALOG_FILES=/usr/local/etc/xml/catalog
export HOMEBREW_NO_GITHUB_API=1

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
#PROMPT_COMMAND='history -a'
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# Save multi-line commands as one command
shopt -s cmdhist

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
CDPATH=".:~:~/Library:~/Projects:~/Projects/Repos:~/Clouds:$GOPATH/src/github.com:$GOPATH/src"

## Old Prompt Prompt Shit
#Known good prompt :)
#export PS1="\[\033]0;\u@\h:\w\007\][\[\e[1m\]\h\[\e[0m\]]Aye, Cap'n? "

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi


## Test for color is actually a test for linux over mac
if [ -f /usr/bin/dircolors ]; then
  test -r ~/.dir_colors && eval "$(dircolors -b ~/.dir_colors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  elif [ -f /usr/local/share/bash-completion/bash_completion ]; then
    . /usr/local/share/bash-completion/bash_completion ;
  elif [ -f /usr/local/share/bash_completion ]; then
    . /usr/local/share/bash_completion
  fi

fi

## Liquid Prompt if shell is interactive
[[ $- = *i* ]] && source ~/bin/liquidprompt/liquidprompt

## Source Functions
[ -f ~/.functions ] && source ~/.functions
## Source Aliases
[ -f ~/.aliases ] && source ~/.aliases
## Source Terraform variables
# include ~/.oci/env-vars

# Ruby Path
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
