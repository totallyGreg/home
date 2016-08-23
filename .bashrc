#echo "bashrc loading..."

setenv()
{
	export $1="$2"
}
unsetenv()
{
	unset $1
}

# display man pages in web browser
function wman() {
   url="man -w ${1} | sed 's#.*\(${1}.\)\([[:digit:]]\).*\$#http://developer.apple.com/documentation/Darwin/Reference/ManPages/man\2/\1\2.html#'"
   open `eval $url`
}

# Growl function for iTerm 
growl() { echo -e $'\e]9;'${1}'\007' ; return ; }

#display man pages in Preview
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
#Known good prompt :)
export PS1="\[\033]0;\u@\h:\w\007\][\[\e[1m\]\h\[\e[0m\]]Aye, Cap'n? "

#PROMPT_COMMAND="settitle ${USER}@$(hostname -s):"'${PWD##*/}'
#export PROMPT_COMMAND='echo -n -e "\033k\033"'
#export PS1="\][\[\e[1m\]\h\[\e[0m\]]Aye, Cap'n? "

# this makes writing to history happen after each prompt
PROMPT_COMMAND='history -a'
export HISTSIZE=1024
export HISTCONTROL=ignoreboth
export HISTIGNORE="&:ls:[bf]g:exit"
export HISTTIMEFORMAT="%T - "
export IGNOREEOF=3
export FCEDIT=vim
export CLICOLOR=1
export LSCOLORS=hxfxcxdxbxegedabagacad
export VIM_APP_DIR="/Applications/Comm/Written/MacVim-snapshot-0712B"

## Options I like
## See .inputrc for Readline options
set -o vi
shopt -s histappend
shopt -s cdspell

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
# Read Log files with embeded control characters (e.g. screenlog.0)
alias readlog='less -raw-control-chars'
##### Completions
#complete -W "$(ls $HOME/Library/Application\ Support/Screen\ Sharing)" vnc

#I forget why I had this in here... 
#source /usr/local/opt/dnvm/bin/dnvm.sh
