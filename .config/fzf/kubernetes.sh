pods(){
  FZF_DEFAULT_COMMAND="kubectl get pods --all-namespaces" \
    fzf --info=inline --layout=reverse --header-lines=1 \
        --prompt "$(kubectl config current-context | sed 's/-context$//')> " \
        --header $'╱ Enter (kubectl exec) ╱ CTRL-O (open log in editor) ╱ CTRL-R (reload) ╱\n\n' \
        --bind 'ctrl-/:change-preview-window(80%,border-bottom|hidden|)' \
        --bind 'enter:execute:kubectl exec -it --namespace {1} {2} -- bash > /dev/tty' \
        --bind 'ctrl-o:execute:${EDITOR:-vim} <(kubectl logs --all-containers --namespace {1} {2}) > /dev/tty' \
        --bind 'ctrl-r:reload:$FZF_DEFAULT_COMMAND' \
        --preview-window up:follow \
        --preview 'kubectl logs --follow --all-containers --tail=10000 --namespace {1} {2}' "$@" 
      }


kdebug() {
  # Inspired by https://iximiuz.com/en/posts/kubernetes-ephemeral-containers/
  POD_NAME=${1}
  TOOL="nicolaka/netshoot"
  # POD_NAME=$(kubectl get pods -l app=slim -o jsonpath='{.items[0].metadata.name}')

  # kubectl debug -it -c debugger --target=${POD_NAME} --image=${TOOL} ${POD_NAME}
  kubectl debug -it --image=${TOOL} ${POD_NAME}
  # Debugging a node
  # kubectl debug node/mynode -it --image=ubuntu

}

show_namespaced_resource() {
  # Useful to show resources preventing a namespace from being deleted
  kubectl api-resources -o name --verbs=list --namespaced | xargs -n 1 kubectl get --show-kind --ignore-not-found -n $1
}
