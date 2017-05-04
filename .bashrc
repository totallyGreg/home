#echo "bashrc loading..."
## Options I like
## See .inputrc for Readline options
set -o vi
shopt -s cdspell
shopt -s checkwinsize

# This makes writing to history happen after each prompt 
# So multiple logins are all sharing history
shopt -s histappend
PROMPT_COMMAND='history -a'

export HISTSIZE=1024
export HISTCONTROL=ignoreboth
export HISTIGNORE="&:ls:[bf]g:exit"
export HISTTIMEFORMAT="%T - "
export TIMEFORMAT="%Rs - "
export IGNOREEOF=3
export FCEDIT=vim
export CLICOLOR=1
export LSCOLORS=hxfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

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

setenv()
{
	export $1="$2"
}
unsetenv()
{
	unset $1
}

#MacOS Specific 

export VIM_APP_DIR="/Applications/Comm/Written/MacVim-snapshot-0712B"

# display man pages in web browser
function wman() {
   url="man -w ${1} | sed 's#.*\(${1}.\)\([[:digit:]]\).*\$#http://developer.apple.com/documentation/Darwin/Reference/ManPages/man\2/\1\2.html#'"
   open `eval $url`
}

# Growl function for iTerm 
growl() { echo -e $'\e]9;'${1}'\007' ; return ; }

#display man pages in Preview.app
pman() { 
	man -t "$@" | open -f -a Preview
}

#settitle()
#{
#    case "$TERM" in
#	xterm* )
#	    echo -ne '\e]0;'"$@"'\a'
#	    ;;
#	screen)
#	    echo -ne '\ek'"$@"'\e\\'
#	    ;;
#    esac
#}
if [ -f /usr/local/bin/dircolors ]; then
        eval `/usr/local/bin/dircolors -c ~/.dircolors`;
fi
CDPATH=".:~:~/Library"

## Prompt Shit
#Known good prompt :)
export PS1="\[\033]0;\u@\h:\w\007\][\[\e[1m\]\h\[\e[0m\]]Aye, Cap'n? "

[[ $- = *i* ]] && source ~/bin/liquidprompt/liquidprompt

#PROMPT_COMMAND="settitle ${USER}@$(hostname -s):"'${PWD##*/}'
#export PROMPT_COMMAND='echo -n -e "\033k\033"'
#export PS1="\][\[\e[1m\]\h\[\e[0m\]]Aye, Cap'n? "

prompt ()
{
    case "$1" in
	error)
	    PS1='$( RET=$?; if [ $RET != 0 ] ; then echo "rc: $RET"; fi )\n\$ '
	;;
        hw)
            PS1='\h: \w \$ '
        ;;
        sh)
            PS1='[$SHLVL]<-\h\$ '
        ;;
        uh)
            PS1='\u@\h\$ '
        ;;
        deploy)
            PS1='\h@\t:\#: \$ '
        ;;
	red)
		# Set RED prompt
		PS1="\[\e[01;31m\]$PS1\[\e[00m\]"
	;;
	*)	PS1='\[\e[1;33m\]\u@\h \w\n\[ |\e[1;36m\]\t \$\[\e[m\] '
		echo "Prompt: error, hw, sh, uh, deploy, red"
	;;
    esac
}



## Beginning of Aliases
alias l='ls -lhF'
alias la='ls -alhF'
alias lt='ls -alhFtr'
alias grep='grep --color'
alias cd..='cd ..'
## Example of ssh tunneling through a gateway machine
#alias rupert='ssh -X -A -t jgreg@peabody.ximian.com ssh -X -A totally@rupert.ximian.com'
alias gn='growlnotify'
alias basement='ssh -X -A totally@172.16.1.1 '
alias netra='ssh -X -A totally@netrabot.svaha.com '
alias excuse='telnet towel.blinkenlights.nl 666'
alias dict='curl dict://dict.org/d:$1'
alias Pattern='cd /Users/PatternBuffer'
alias backscreen='/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background &'
alias burn='hdiutil burn'
alias eject='hdiutil eject'
alias ttop='top -ocpu -R -F -s 2 -n30'
alias mtop='top -o rsize'
alias quick='open /Applications/Ops/Administration/Quicksilver.app'
alias futurama='fortune futurama'
alias tmount='/Applications/Ops/Engineering/Archival/Toast\ 8\ Titanium/Toast\ Titanium.app/Contents/MacOS/ToastImageMounter'
alias fc='dscacheutil -flushcache'
alias nyancat='telnet miku.acm.uiuc.edu'
alias serialscreen='screen -L /dev/cu.usbserial -f 9600,cs8,-parenb,-cstopb,-hupcl'
alias diff='opendiff'
# Read Log files with embeded control characters (e.g. screenlog.0)
alias readlog='less -raw-control-chars'
##### Dotfile management through git work-tree
alias dotadm='/usr/bin/git --git-dir=$HOME/.home/ --work-tree=$HOME'

##### Completions
#complete -W "$(ls $HOME/Library/Application\ Support/Screen\ Sharing)" vnc

#I forget why I had this in here... 
#source /usr/local/opt/dnvm/bin/dnvm.sh

