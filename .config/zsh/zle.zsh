# Testing out creating my own widgets
# Bind \eg to `git status`
function _git-status {
    zle kill-whole-line
    zle -U "git status"
    zle accept-line
}
zle -N _git-status
bindkey '\eg' _git-status

function watch-command {
    # If line buffer is full (i.e. I've started typing)
    # insert the watch command in front of text
    zle vi-beginning-of-line
    # if line buffer empty, assume I want to watch the last command from history
    # or better yet run watch with an fzf list of history
    # Or simply add an fzf keybinding to insert watch from history or all of these!

}
zle -N watch-command
