#Shell Variables
# ENV variables
export TIMEFORMAT="%Rs - "
export IGNOREEOF=3
export FCEDIT=vim
export EDITOR=vim
export XML_CATALOG_FILES=/usr/local/etc/xml/catalog
export HOMEBREW_NO_GITHUB_API=1
export CLICOLOR=1
# Directories Blue, Symlinks cyan
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

## HISTORY
HISTSIZE=500000
HISTFILESIZE=1000000
HISTCONTROL=ignoreboth
HISTIGNORE="&:[ ]*:exit:ls:[bf]g:history:clear:"
HISTTIMEFORMAT='%F %T ' #  Use standard ISO 8601 timestamp %F equivalent to %Y-%m-%d %T equivalent to %H:%M:%S (24-hours format)
# This makes writing to history happen after each prompt
shopt -s cmdhist      # Save multi-line commands as one command
shopt -s histappend   # So multiple logins are all sharing history
# https://unix.stackexchange.com/questions/18212/bash-history-ignoredups-and-erasedups-setting-conflict-with-common-history
# PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -n; history -w; history -c; history -r"
# PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
PROMPT_COMMAND="history -a; history -n; history -r; $PROMPT_COMMAND"

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
CDPATH=".:~:~/Library:~/Projects:~/Repositories:~/Clouds:$GOPATH/src/github.com:$GOPATH/src"

# FZF may make most of this obsolete
# export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore node_modules --ignore ~/Library --ignore ~/Music/Audio Music Apps/ --ignore Library -g ""'
export FZF_DEFAULT_COMMAND='ag -l --ignore ~/Music --nocolor -g ""'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -100'"



# Bash Hook for direnv
if ! hash direnv 2>/dev/null; then
  echo ""
else
  eval "$(direnv hook bash)"
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
# sources /etc/bash.bashrc). Requires BASH version 4
if ! shopt -oq posix && [ "${BASH_VERSINFO:-0}" -ge 4 ]; then
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

## Source Prompt
[ -f ~/.promptline.sh ] && source ~/.promptline.sh
## Source Functions
[ -f ~/.functions ] && source ~/.functions
## Source Aliases
[ -f ~/.aliases ] && source ~/.aliases
## Source Terraform variables
# include ~/.oci/env-vars
[ -f ~/.fzf.bash  ] && source ~/.fzf.bash
