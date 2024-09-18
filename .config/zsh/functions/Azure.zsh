# Fuzzy Azure account switch
faz() {
  # This function will list all of the accounts
  # filter them with fzf
  # and set the current account to the one selected
  local JMESPath_template subscription_name 
  JMESPath_template='[].{name: name, subscriptionId: id}'
  subscription_name=$(
    az account list -o table \
      --query $JMESPath_template |
      fzf-down \
        --header-lines=2 \
        --nth='1,2' \
        --height="50%" \
        --min-height=17 \
        --preview='az account show -o json -s {-1}| jq -C' |
       rev | cut -d' ' -f1 | rev
    )

  if [ -n "$subscription_name" ] ; then
    az account set --subscription $subscription_name && az account show
  fi
}

# Azure functions to keep costs down
aks_up() {
  # : Usage: aks_up [resource_group]
  # : "This will start the VM's associated with a Resource Group "
  # nodeResourceGroup=$(az aks list --query '[].nodeResourceGroup' -o table  | fzf-down --header-lines=2)
  # az vm start --ids \
  #   "$(az vm list -g "$nodeResourceGroup" --query '[].id' -o tsv)"
  # az vm start --ids $(az vm list -g "$nodeResourceGroup" --query '[].id' -o tsv)
  read vmss_name nodeResourceGroup <<<$(az vmss list -o table \
   --query '[].{Name: name, ResourceGroup: resourceGroup}' | \
   fzf-down --header-lines=2 --nth='1,2')

  if [ -n "${vmss_name}" ]  && [ -n "${nodeResourceGroup}" ]; then
    az vmss start -n ${vmss_name} -g ${nodeResourceGroup}
  fi
  # while [[ $(kubectl get nodes -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for nodes" && sleep 1; done
}

aks_down() {
  # : Usage: aks_down [resource_group]
  # : "This will deallocate the VM's associated with a Resource Group"
  # local preview="az list"
  # local VMSS_list_dict="$(az vmss list --query '[].{Name: name, ResourceGroup: resourceGroup}'"
  # nodeResourceGroup=$(az aks list --query '[].nodeResourceGroup' -o table  | fzf-down --header-lines=2)
  read vmss_name nodeResourceGroup <<<$(az vmss list -o table \
   --query '[].{Name: name, ResourceGroup: resourceGroup}' | \
   fzf-down --header-lines=2 --nth='1,2')

  if [ -n "${vmss_name}" ]  && [ -n "${nodeResourceGroup}" ]; then
    az vmss deallocate -n ${vmss_name} -g ${nodeResourceGroup}
  fi
}
