# Testing out creating my own widgets
# Bind \eg to `git status`
function _git-status {
    zle kill-whole-line
    zle -U "git status"
    zle accept-line
}
zle -N _git-status
bindkey '\eg' _git-status

.toggle-watch(){
    .toggle-command-prefix 'watch ' 'watch'
}
# zle -N watch-command
zle -N .toggle-watch
bindkey '\ew' .toggle-watch     # Alt-W to toggle watch or apply to previous command

# Open command line in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line
