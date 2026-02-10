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
setopt auto_cd           # if a command isn't valid, but is a directory, cd to that dir
setopt auto_pushd        # make cd push the old directory onto the directory stack
setopt pushd_ignore_dups # don’t push multiple copies of the same directory onto the directory stack
setopt pushd_minus       # exchanges the meanings of ‘+’ and ‘-’ when specifying a directory in the stack
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

export CLICOLOR=1
export LSCOLORS="exfxcxdxbxegedabagacad"
# From `gdircolors ~/.dir_colors` which is https://github.com/seebi/dircolors-solarized/blob/master/dircolors.ansi-universal
LS_COLORS='no=00:fi=00:di=34:ln=35:pi=30;44:so=35;44:do=35;44:bd=33;44:cd=37;44:or=05;37;41:mi=05;37;41:ex=01;31:*.cmd=01;31:*.exe=01;31:*.com=01;31:*.bat=01;31:*.reg=01;31:*.app=01;31:*.txt=32:*.org=32:*.md=32:*.mkd=32:*.bib=32:*.h=32:*.hpp=32:*.c=32:*.C=32:*.cc=32:*.cpp=32:*.cxx=32:*.objc=32:*.cl=32:*.sh=32:*.bash=32:*.csh=32:*.zsh=32:*.el=32:*.vim=32:*.java=32:*.pl=32:*.pm=32:*.py=32:*.rb=32:*.hs=32:*.php=32:*.htm=32:*.html=32:*.shtml=32:*.erb=32:*.haml=32:*.xml=32:*.rdf=32:*.css=32:*.sass=32:*.scss=32:*.less=32:*.js=32:*.coffee=32:*.man=32:*.0=32:*.1=32:*.2=32:*.3=32:*.4=32:*.5=32:*.6=32:*.7=32:*.8=32:*.9=32:*.l=32:*.n=32:*.p=32:*.pod=32:*.tex=32:*.go=32:*.sql=32:*.csv=32:*.sv=32:*.svh=32:*.v=32:*.vh=32:*.vhd=32:*.bmp=33:*.cgm=33:*.dl=33:*.dvi=33:*.emf=33:*.eps=33:*.gif=33:*.jpeg=33:*.jpg=33:*.JPG=33:*.mng=33:*.pbm=33:*.pcx=33:*.pgm=33:*.png=33:*.PNG=33:*.ppm=33:*.pps=33:*.ppsx=33:*.ps=33:*.svg=33:*.svgz=33:*.tga=33:*.tif=33:*.tiff=33:*.xbm=33:*.xcf=33:*.xpm=33:*.xwd=33:*.xwd=33:*.yuv=33:*.NEF=33:*.nef=33:*.webp=33:*.heic=33:*.HEIC=33:*.avif=33:*.aac=33:*.au=33:*.flac=33:*.m4a=33:*.m4b=33:*.mid=33:*.midi=33:*.mka=33:*.mp3=33:*.mpa=33:*.mpeg=33:*.mpg=33:*.ogg=33:*.opus=33:*.ra=33:*.wav=33:*.anx=33:*.asf=33:*.avi=33:*.axv=33:*.flc=33:*.fli=33:*.flv=33:*.gl=33:*.m2v=33:*.m4v=33:*.mkv=33:*.mov=33:*.MOV=33:*.mp4=33:*.mp4v=33:*.mpeg=33:*.mpg=33:*.nuv=33:*.ogm=33:*.ogv=33:*.ogx=33:*.qt=33:*.rm=33:*.rmvb=33:*.swf=33:*.vob=33:*.webm=33:*.wmv=33:*.doc=31:*.docx=31:*.rtf=31:*.odt=31:*.dot=31:*.dotx=31:*.ott=31:*.xls=31:*.xlsx=31:*.ods=31:*.ots=31:*.ppt=31:*.pptx=31:*.odp=31:*.otp=31:*.fla=31:*.psd=31:*.pdf=31:*.7z=1;35:*.apk=1;35:*.arj=1;35:*.bin=1;35:*.bz=1;35:*.bz2=1;35:*.cab=1;35:*.deb=1;35:*.dmg=1;35:*.gem=1;35:*.gz=1;35:*.iso=1;35:*.jar=1;35:*.msi=1;35:*.rar=1;35:*.rpm=1;35:*.tar=1;35:*.tbz=1;35:*.tbz2=1;35:*.tgz=1;35:*.tx=1;35:*.war=1;35:*.xpi=1;35:*.xz=1;35:*.z=1;35:*.Z=1;35:*.zip=1;35:*.zst=1;35:*.ANSI-30-black=30:*.ANSI-01;30-brblack=01;30:*.ANSI-31-red=31:*.ANSI-01;31-brred=01;31:*.ANSI-32-green=32:*.ANSI-01;32-brgreen=01;32:*.ANSI-33-yellow=33:*.ANSI-01;33-bryellow=01;33:*.ANSI-34-blue=34:*.ANSI-01;34-brblue=01;34:*.ANSI-35-magenta=35:*.ANSI-01;35-brmagenta=01;35:*.ANSI-36-cyan=36:*.ANSI-01;36-brcyan=01;36:*.ANSI-37-white=37:*.ANSI-01;37-brwhite=01;37:*.log=01;32:*~=01;32:*#=01;32:*.bak=01;36:*.BAK=01;36:*.old=01;36:*.OLD=01;36:*.org_archive=01;36:*.off=01;36:*.OFF=01;36:*.dist=01;36:*.DIST=01;36:*.orig=01;36:*.ORIG=01;36:*.swp=01;36:*.swo=01;36:*.v=01;36:*.gpg=34:*.pgp=34:*.asc=34:*.3des=34:*.aes=34:*.enc=34:*.sqlite=34:*.db=34:'
export LS_COLORS
# ZLS_COLOR is getting set automatically by fzf-tab
# Aloxaf/fzf-tab/README.md
# 140:By default, fzf-tab uses [zsh-ls-colors](https://github.com/xPMo/zsh-ls-colors) to parse and apply ZLS_COLORS if you have set the `list-colors` tag.

# # Homebrew path is now set in ~/.zshenv so non-interactive shells can use tools

# Java
path=(/opt/homebrew/opt/openjdk/bin $path)

# Ruby setup
if command -v rbenv 1>/dev/null 2>&1; then
  eval "$(rbenv init - zsh)"
fi

# Apple Xcode Path
if [ -d /Library/Developer/CommandLineTools/usr/bin ]; then
  path=(/Library/Developer/CommandLineTools/usr/bin $path)
  export CC=$(xcrun --find clang)
  export CXX=$(xcrun --find clang++)
fi

# OpenSSL that generates valid
if [ -d /usr/local/opt/openssl@3/bin ]; then
  path=(/usr/local/opt/openssl@3/bin $path)
fi

# Setup Go environment
export GOPATH="${HOME}/Documents/Projects/golang"
export GOROOT="$(brew --prefix golang)/libexec" # no longer recommended? https://stackoverflow.com/questions/7970390/what-should-be-the-values-of-gopath-and-goroot/45529403#45529403
# export GOROOT=~/.local/share/golang
export PATH="$PATH:${GOPATH}/bin"
export CGO_CFLAGS="-g -O2 -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"
# export PATH="$PATH:${GOROOT}/bin" # Not needed with brew install go

# Cargo
path=(${HOME}/.cargo/bin $path)
# From https://braindetour.com/article/20220213 but still getting linker errors
# export PATH=$PATH:/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib # Needed for Rust compilation and linking
# export LIBRARY_PATH=$LIBRARY_PATH:/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib # Needed for Rust compilation and linking

# Rancher-Desktop
path=(${HOME}/.rd/bin $path)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then . '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'; fi

# # Kubernetes
# set_kubeconfig () {
#   typeset -xT KUBECONFIG kubeconfig       # tie scalar and array together making adding easier
#   KUBECONFIG="$HOME/.kube/config"         # many tools assume only this file or it is FIRST in path
#
#   # List of common directories that contain kubeconfig files to append to my KUBECONFIG
#   # It is necessary for these to have unique values for cluster and user so the context merging doesn't conflict
#   local kube_dirs=(
#   ${HOME}/.kube/config.d
#   ${HOME}/.kube/eksctl/clusters
#   ${HOME}/.k3d
#   ${HOME}/.kube/gke
# )
#   # This will create a list of config files located in $kube_dir
#   # while ignoring any errors (directories that don't exist)
#   kubeConfigFileList=$(find ${kube_dirs} -type f \( -name '*.yaml' -o -name '*.yml' \) 2>/dev/null)
#   # for file in $(ls -d -1 $HOME/.lima/*/conf/kubeconfig.yam)
#   #   do kubeConfigFileList+=$file
#   # done
#
#   # Combine all file paths into the single `KUBECONFIG` path variable.
#   while IFS= read -r kubeConfigFile; do
#     kubeconfig+="${kubeConfigFile}"
#   done <<< ${kubeConfigFileList}
#
#   # This appears necessary to join it back into a PATH type variable
#   # KUBECONFIG=${(j.:.)kubeconfig}
# }

export KUBECTL_EXTERNAL_DIFF="dyff between --omit-header --set-exit-code"
path=(${KREW_ROOT:-$HOME/.krew}/bin $path)
export HELM_EXPERIMENTAL_OCI=1
export K9SCONFIG=$XDG_CONFIG_HOME/k9s

# My stuff
# PATH=${HOME}/bin:$PATH

# GPG Agent consistent across tmux shells
if type gpg &>/dev/null; then
  export GPG_TTY=$(tty)
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  gpgconf --launch gpg-agent
  # Switch does not actually seem to work on pinentry-mac
  if [[ -n "$SSH_CONNECTION" ]]; then
    export PINENTRY_USER_DATA="USE_CURSES=1"
  fi
else
  # echo "GPG not found using ssh-agent"
fi

# Update tmux environment variables before each prompt
if [[ -n "$TMUX" ]]; then
  tmux_update_env() {
    eval "$(tmux show-env -s)"
  }
  precmd_functions+=(tmux_update_env)
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
alias -s {yml,yaml}=nvim # quick editing of yaml files in nvim

[ -f ~/.aliases ] && source ~/.aliases

## Source Functions after aliases
## Autoload functions you might want to use with antidote.
ZFUNCDIR=${ZFUNCDIR:-$ZDOTDIR/functions}
# fpath=($ZFUNCDIR $fpath)
# autoload -Uz $fpath[1]/*(.:t)

## Clone zcomet if necessary
if [[ ! -f ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh ]]; then
  git clone https://github.com/agkozak/zcomet.git ${ZDOTDIR:-${HOME}}/.zcomet/bin
fi

# Source zcomet.zsh
source ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh
zstyle ':zcomet:compinit' dump-file $XDG_CACHE_HOME/zsh/zcompdump

## Load some plugins
# zcomet load jeffreytse/zsh-vi-mode            # Better vim support including surrounds and increments
# ZVM_VI_HIGHLIGHT_BACKGROUND=yellow            # default is red, but zvm seems to break y)anking
#
# Testing out the auto appearance
zcomet load alberti42/zsh-appearance-control

zcomet load zsh-users/zsh-completions
zcomet load mattmc3/zephyr plugins/completion
# zcomet load asdf-vm/asdf
zcomet load mattmc3/zephyr plugins/homebrew
zcomet load mattmc3/zephyr plugins/macos
zcomet load mattmc3/zephyr plugins/zfunctions
zcomet load mattmc3/zman

# Run compinit and compile its cache
zcomet compinit

# Install Fzf, eventually homebrew version will take precedence
zcomet load junegunn/fzf # shell completion.zsh key-bindings.zsh
# source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf_env.zsh (now loaded from conf.d)
zcomet load Aloxaf/fzf-tab
# zcomet load Freed-Wu/fzf-tab-source # ⚙️ a collection of fzf-tab completion sources.
zcomet load reegnz/jq-zsh-plugin # Interactive jq explorer
# zcomet load jeffreytse/zsh-vi-mode # Better Vim mode https://github.com/jeffreytse/zsh-vi-mode
# I suspect this needs to be loaded in a different order

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
# zcomet load z-shell/zsh-fancy-completions
zcomet load zsh-users/zsh-autosuggestions
zcomet load mattmc3/zephyr plugins/confd # autosuggestions wants the keybinds after the plugin has been installed
zcomet load mattmc3/zephyr plugins/color
# Set custom fast syntax highlighting work directory
# FAST_WORK_DIR=XDG
# zcomet load zdharma-continuum/fast-syntax-highlighting  #I've given up trying to figure out how to make themes persistent
zcomet load zsh-users/zsh-syntax-highlighting # https://github.com/zsh-users/zsh-syntax-highlighting/pull/749 merged @feature/redrawhook
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(main brackets pattern cursor line)
ZSH_HIGHLIGHT_MAXLENGTH=512
# This fails with syntax.zsh:3: ZSH_HIGHLIGHT_STYLES: assignment to invalid subscript range
ZSH_HIGHLIGHT_STYLES[comment]='fg=241'

# Since Google is doing their own test of whether or not to add completions instead of adding to fpath
# It has to be added after the compinit is compiled
# The next line enables shell command completion for gcloud.
if [ -f "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc" ]; then
  source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
  source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
fi
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# Testing Switcher as a per shell option
if (hash switcher >/dev/null 2>&1); then
  source <(switcher init zsh)
  source <(switch completion zsh)
  alias s=switch
fi

### Starship prompt
eval "$(starship init zsh)"
### Zoxide
if command -v zoxide 1>/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias cd=z #NOTE: Old habits die hard
  # _ZO_FZF_OPTS=""
fi
### direnv
# whence -w $1 >/dev/null
if command -v direnv 1>/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"

if [[ "$PROFILE_STARTUP" == true ]]; then
  unsetopt xtrace
  exec 2>&3 3>&-
  zprof >~/zshprofile$(date +'%s')
fi
