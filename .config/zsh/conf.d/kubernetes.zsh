# Kubernetes
set_kubeconfig () {
  typeset -xT KUBECONFIG kubeconfig       # tie scalar and array together making adding easier
  KUBECONFIG="$HOME/.kube/config"         # many tools assume only this file or it is FIRST in path

  # List of common directories that contain kubeconfig files to append to my KUBECONFIG
  # It is necessary for these to have unique values for cluster and user so the context merging doesn't conflict
  local kube_dirs=(
  ${HOME}/.kube/config.d
  ${HOME}/.kube/eksctl/clusters
  ${HOME}/.k3d
  ${HOME}/.kube/gke
)
  # ${HOME}/.lima/*/copied-from-guest :this is ugly as default is everywhere

  # This will create a list of config files located in $kube_dir
  # while ignoring any errors (directories that don't exist)
  kubeConfigFileList=$(find ${kube_dirs} -type f \( -name '*.yaml' -o -name '*.yml' \) 2>/dev/null)
  # for file in $(ls -d -1 $HOME/.lima/*/conf/kubeconfig.yam)
  #   do kubeConfigFileList+=$file
  # done

  # Combine all file paths into the single `KUBECONFIG` path variable.
  while IFS= read -r kubeConfigFile; do
    kubeconfig+="${kubeConfigFile}"
  done <<< ${kubeConfigFileList}
}
set_kubeconfig


set_kubeconfig_shell() {
  # Create a unique KUBECONFIG for the shell
  SHELL_KUBECONFIG="$HOME/.kube/config-$(uuidgen)"
  kubectl config view --flatten > "$SHELL_KUBECONFIG"
  export KUBECONFIG="${SHELL_KUBECONFIG}"
  kctx
  # trap "rm $KUBECONFIG" EXIT
}
