#!/usr/bin/env zsh
PROFILE_STARTUP=false

if [[ "$PROFILE_STARTUP" == true ]]; then
  zmodload zsh/zprof
  PS4=$'%D{%M%S%.} %N:%i> '
  exec 3>&2 2>$HOME/startlog.$$
  setopt xtrace prompt_subst
fi

emulate zsh

# Gotsta have vi bindings
export EDITOR=nvim
bindkey -v

# # History settings are now in config.d/history.zsh

# Changing Directories
# http://zsh.sourceforge.net/Doc/Release/Options.html#Changing-Directories
setopt auto_cd                 # if a command isn't valid, but is a directory, cd to that dir
setopt auto_pushd              # make cd push the old directory onto the directory stack
setopt pushd_ignore_dups       # don’t push multiple copies of the same directory onto the directory stack
setopt pushd_minus             # exchanges the meanings of ‘+’ and ‘-’ when specifying a directory in the stack
# setopt cdablevars
cdpath=($HOME $HOME/Repositories $HOME/Downloads $HOME/Work)

# iCloud Obscured Locations
if [ -d "${HOME}/Library/Mobile Documents/com~apple~CloudDocs" ]; then
  export iCloud="${HOME}/Clouds/iCloud"
  hash -d iCloud=~/Library/Mobile\ Documents/com\~apple\~CloudDocs
  hash -d audiobooks=~/Library/Containers/com.apple.BKAgentService/Data/Documents/iBooks/Books/audiobooks
  hash -d books=~/Library/Containers/com.apple.BKAgentService/Data/Documents/iBooks/Books
  hash -d obsidian=~/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents
  hash -d podcasts=~/Library/Group\ Containers/243LU875E5.groups.com.apple.podcasts
fi

# Other misc settings
LISTMAX=0

# Yes, these are a pain to customize. Fortunately, Geoff Greer made an online
# tool that makes it easy to customize your color scheme and keep them in sync
# # across Linux and OS X/*BSD at http://geoff.greer.fm/lscolors/
export LS_COLORS='no=00:fi=00:di=01;33:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jpg=01;35:*.png=01;35:*.gif=01;35:*.bmp=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.png=01;35:*.mpg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:';

# eval  `dircolors -b`
export ZLS_COLORS=$LS_COLORS

# # Homebrew path is now set in ~/.zshenv so non-interactive shells can use tools

# Linuxbrew
# test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
# test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# Python globally managed by pyenv
# https://opensource.com/article/19/5/python-3-default-mac#what-to-do
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv virtualenv-init -)"
fi

# Apple Xcode Path
if [ -d /Library/Developer/CommandLineTools/usr/bin ] ; then
  export PATH=/Library/Developer/CommandLineTools/usr/bin:$PATH
  export CC=$(xcrun --find clang)
  export CXX=$(xcrun --find clang++)
fi

# OpenSSL that generates valid 
if [ -d /usr/local/opt/openssl@3/bin ] ; then
  export PATH="/usr/local/opt/openssl@3/bin:$PATH"
fi

# Setup Go environment
export GOPATH="${HOME}/Work/go"
# export GOROOT="$(brew --prefix golang)/libexec"
export GOROOT=~/.local/share/golang
export PATH="$PATH:${GOPATH}/bin"
export CGO_CFLAGS="-g -O2 -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"
# export PATH="$PATH:${GOROOT}/bin" # Not needed with brew install go

# Cargo
PATH=${HOME}/.cargo/bin:$PATH
# From https://braindetour.com/article/20220213 but still getting linker errors
# export PATH=$PATH:/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib # Needed for Rust compilation and linking
# export LIBRARY_PATH=$LIBRARY_PATH:/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib # Needed for Rust compilation and linking

# Rancher-Desktop
PATH=${HOME}/.rd/bin:$PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then . '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'; fi

# Kubernetes
set_kubeconfig () {
  typeset -xT KUBECONFIG kubeconfig       # tie scalar and array together making adding easier
  KUBECONFIG="$HOME/.kube/config"         # many tools assume only this file or it is first in path

  # List of common directories that contain kubeconfig files to add to my KUBECONFIG
  local kube_dirs=(
  ${HOME}/.kube/config.d
  ${HOME}/.kube/eksctl/clusters
  ${HOME}/.k3d
  ${HOME}/.kube/gke
)
  # This will create a list of config files located in $kube_dir
  # while ignoring any errors (directories that don't exist)
  kubeConfigFileList=$(find ${kube_dirs} -type f 2>/dev/null)
  # for file in $(ls -d -1 $HOME/.lima/*/conf/kubeconfig.yam)
  #   do kubeConfigFileList+=$file
  # done

  # Combine all file paths into the single `KUBECONFIG` path variable.
  while IFS= read -r kubeConfigFile; do
    kubeconfig+="${kubeConfigFile}"
  done <<< ${kubeConfigFileList}

  # This appears necessary to join it back into a PATH type variable
  # KUBECONFIG=${(j.:.)kubeconfig}
}
set_kubeconfig

set_kubeconfig_shell() {
  # Create a unique KUBECONFIG for the shell
  export KUBECONFIG="$HOME/.kube/config-$(uuidgen)"
  cp $HOME/.kube/config "$KUBECONFIG"
  trap "rm $KUBECONFIG" EXIT
}

export KUBECTL_EXTERNAL_DIFF="dyff between --omit-header --set-exit-code"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export HELM_EXPERIMENTAL_OCI=1
export K9SCONFIG=$XDG_CONFIG_HOME/k9s

# My stuff
# PATH=${HOME}/bin:$PATH

# GPG Agent
if type gpg &>/dev/null; then
  export GPG_TTY=$(tty)
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  gpgconf --launch gpg-agent
else
  # echo "GPG not found using ssh-agent"
fi

# Unique the paths
typeset -U fpath kubeconfig cdpath 
export FPATH KUBECONFIG

# Session Sauce variable
typeset -TUx SESS_PROJECT_ROOT sess_project_root
sess_project_root=(~/Work/Customers)

# Zsh Specific Aliases
alias mv='nocorrect mv'       # no spelling correction on mv
alias cp='nocorrect cp'       # no spelling correction on cp
alias mkdir='nocorrect mkdir' # no spelling correction on mkdir
alias dirs='dirs -v'
alias -s {yml,yaml}=vim       # quick editing of yaml files in vim

[ -f ~/.aliases ] && source ~/.aliases

## Source Functions after aliases
## Autoload functions you might want to use with antidote.
# ZFUNCDIR=${ZFUNCDIR:-$ZDOTDIR/functions}
# fpath=($ZFUNCDIR $fpath)
# autoload -Uz $fpath[1]/*(.:t)

## Clone zcomet if necessary
if [[ ! -f ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh ]]; then
  git clone https://github.com/agkozak/zcomet.git ${ZDOTDIR:-${HOME}}/.zcomet/bin
fi

# Source zcomet.zsh
source ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh

# Install Fzf
zcomet load junegunn/fzf shell completion.zsh key-bindings.zsh
( (( ${+commands[fzf]} )) || ~[fzf]/install --bin ) && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf_env.zsh


# My FZF based configuration and extra functions
# (( ${+commands[fzf]} )) && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf_env.zsh

## Load some plugins
zcomet load zsh-users/zsh-completions
zcomet load mattmc3/zephyr plugins/completion
zcomet load asdf-vm/asdf
zcomet load mattmc3/zephyr plugins/color
zcomet load mattmc3/zephyr plugins/homebrew
zcomet load mattmc3/zephyr plugins/macos
zcomet load mattmc3/zephyr plugins/zfunctions
zcomet load Aloxaf/fzf-tab
zcomet load reegnz/jq-zsh-plugin  # Interactive jq explorer

#
# zcomet load xPMo/zsh-toggle-command-prefix # keeps throwing sudo errors 
# zcomet load starship/starship
# zcomet load kubermatic/fubectl # https://github.com/kubermatic/fubectl
# zcomet load ChrisPenner/session-sauce

# Lazy-load some plugins
zcomet trigger zhooks agkozak/zhooks
# zcomet trigger zsh-prompt-benchmark romkatv/zsh-prompt-benchmark

# This breaks all kinds of aliases and who knows what else
# But I really must steal the security keychain bits
# zinit light unixorn/tumult.plugin.zsh

## These plugins which will wrap widgets prefer to be last
zcomet load zdharma-continuum/fast-syntax-highlighting
zcomet load zsh-users/zsh-autosuggestions
zcomet load mattmc3/zephyr plugins/confd     # autosuggestions wants the keybinds after the plugin has been installed
# zcomet load zsh-users/zsh-syntax-highlighting

# Set custom fast syntax highlighting work directory
FAST_WORK_DIR=XDG

# Since google is doing their own test of whether or not to add completions instead of adding to fpath
# It has to be added after the compinit is compiled
# The next line enables shell command completion for gcloud.
if [ -f "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc" ];
  then
    source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc";
    source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc";
fi
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# Run compinit and compile its cache
zcomet compinit

### Starship prompt
eval "$(starship init zsh)"
### Zoxide
eval "$(zoxide init zsh)"
### direnv
eval "$(direnv hook zsh)"

# source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"

if [[ "$PROFILE_STARTUP" == true ]]; then
  unsetopt xtrace
  exec 2>&3 3>&-; zprof > ~/zshprofile$(date +'%s')
fi
