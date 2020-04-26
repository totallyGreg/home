# Setup for most environments a lot of old solaris craft in here
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    FreeBSD*)   machine=FreeBSD;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo "Running on ${machine}"

# Auto Tmux startup/resume
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
  # New auto tmux which might work better for ssh sessions
  # Test for ssh session first then use this
  # tmux attach -t default || exec tmux new-session -s default && exit;
fi

# Poorly setup machines will often forget this
export LC_CTYPE=en_US.UTF-8

pathappend() {
  for ARG in "$@"
  do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
        PATH="${PATH:+"$PATH:"}$ARG"
    fi
  done
}

# set up basic path
export PATH=/usr/bin:/bin
[ -d /sbin ] && export PATH=/sbin:${PATH}
[ -d /usr/sbin ] && export PATH=/usr/sbin:${PATH}
[ -d /usr/sadm/bin ] && export PATH=/usr/sadm/bin:${PATH}
[ -d /usr/ccs/bin ] && export PATH=/usr/ccs/bin:${PATH}
[ -d /usr/local/sbin ] && export PATH=/usr/local/sbin:${PATH}
[ -d /usr/bin/X11 ] && export PATH=/usr/bin/X11:${PATH}
[ -d /usr/X11R6/bin ] && export PATH=/usr/X11R6/bin:${PATH}
[ -d /usr/openwin/bin ] && export PATH=/usr/openwin/bin:${PATH}
[ -d /usr/dt/bin ] && export PATH=/usr/dt/bin:${PATH}
[ -d /usr/local/bin ] && export PATH=/usr/local/bin:${PATH}
[ -d /opt/local/bin ] && export PATH=/opt/local/bin:${PATH}
[ -d /opt/local/sbin ] && export PATH=/opt/local/sbin:${PATH}
[ -d /opt/gnome/bin ] && export PATH=/opt/gnome/bin:${PATH}
[ -d /usr/sfw/bin ] && export PATH=/usr/sfw/bin:${PATH}
[ -d /opt/sfw/bin ] && export PATH=/opt/sfw/bin:${PATH}
[ -d /usr/local/ssl/bin ] && export PATH=/usr/local/ssl/bin:${PATH}
[ -d /usr/local/share/python ] && export PATH=/usr/local/share/python:${PATH}
[ -d /usr/local/miniconda3/bin ] && export PATH=/usr/local/miniconda3/bin:"$PATH"
[ -d /snap/bin ] && export PATH=/snap/bin:${PATH}
[ -d ${HOME}/bin ] && export PATH=${HOME}/bin:${PATH}
[ -d $HOME/.linuxbrew/bin ] && export PATH=$HOME/.linuxbrew/bin:"$PATH"
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
[ -d $HOME/.rvm/bin ] && export PATH="$PATH":$HOME/.rvm/bin

# iCloud Obscured Locations
[ -d "${HOME}/Library/Mobile Documents/com~apple~CloudDocs" ] && export iCloud="${HOME}/Clouds/iCloud"
export Books=${HOME}/Library/Containers/com.apple.BKAgentService/Data/Documents/iBooks/Books
export Podcasts="${HOME}/Library/Group Containers/243LU875E5.groups.com.apple.podcasts"

# XDG Base Directory Specification https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share

# Homebrew
export HOMEBREW_BUNDLE_FILE=${XDG_CONFIG_HOME}/Brewfile
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

# Linuxbrew
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# Enable the fuck if it exists
command -v thefuck >/dev/null 2>&1 && eval "$(thefuck --alias)"

# virtualenv
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Projects
export PYTHONPATH=/usr/local//bin/python3
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
[ -f /usr/local/bin/virtualenvwrapper.shi ] && source /usr/local/bin/virtualenvwrapper.sh

# Kubernetes
export KUBECONFIG=$KUBECONFIG:$HOME/.kube/config
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
# Need for the tmux-exec plugin to kubectl
export GNU_GETOPT_PREFIX="$(brew --prefix gnu-getopt)"

# Setup Go environment
export GOPATH="${HOME}/.go"
# export GOROOT="$(brew --prefix golang)/libexec"
# export GOROOT="/usr/local/go"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
