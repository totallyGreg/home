#!/bin/bash
# An initial attempt at programatically obtaining and then 
# inserting credentials into the concourse credhub.
# Create loop to go through list of necessary credentials
# and add them to the appropriate path in credhub
# May want to look at this tool Pivotal “vars-to-creds” CLI
# https://github.com/pivotalservices/vars-to-credhub for bulk insertions

export DOPPLER_CLIENT_CREDENTIALS=$(om credentials --credential-reference  .uaa.doppler_client_credentials --product-name cf --format json)

# Appdynamics Platform credentials example
# export NOZZLE_CREDENTIALS=$(om credentials --credential-reference  .uaa.opentsdb_nozzle_credentials --product-name cf --format json)
# identity=$(echo $NOZZLE_CREDENTIAL | jq '.identity' )
# password=$(echo $NOZZLE_CREDENTIAL | jq '.password' )
# credhub set -t user -n /concourse/npcf03/nozzle_credential -z $identity -w $password

# A list of credential references that should be obtained with the om command
credential_references=(
.uaa.opentsdb_nozzle_credentials
.properties.appd_access_secret
.properties.appd_ma_user_secret
.properties.nozzle_secret
)

function get_credentials()
{
  product=$1
  cred_ref=$2
  credentials=$(om credentials --credential-reference $cred_ref  --product-name $product --format json)
  echo $credentials
}

for credential in ${credentials[*]}; do
  identity=$(echo $credential | jq '.identity' )
  password=$(echo $credential | jq '.password' )
  credhub set -t user -n $credhub_path -z $identity -w $password
done

