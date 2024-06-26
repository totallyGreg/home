# Select a docker container to start and attach to
function da() {
    local cid
      cid=$(docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')

        [ -n "$cid" ] && docker start "$cid" && docker attach "$cid"
}
# Select a running docker container to stop
function ds() {
    local cid
      cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')

        [ -n "$cid" ] && docker stop "$cid"
}
# Select a docker container to remove
function drm() {
    local cid
      cid=$(docker ps -a | sed 1d | fzf -q "$1" | awk '{print $1}')

        [ -n "$cid" ] && docker rm "$cid"
}
