#!/bin/bash -e

om_version=$(om --version)
echo "Running om version ${om_version}"

repo_dir=$(git rev-parse --show-toplevel)

# if IAAS not set assume working directory
if [ -z "$IAAS" ]; then
  iaas_dir=$(pwd)
  IAAS="$(basename ${iaas_dir})"
fi

if [ ! $# -eq 1 ]; then
  echo "Currently this script expects to be run from an iaas/${iaas} directory"
  echo "Must supply product name as arg. ( e.g generate-config.sh cf )"
  exit 1
fi

product=$1
: ${product?"Need to set product"}
: ${PIVNET_TOKEN?"Need to set PIVNET_TOKEN"}
: ${IAAS?"Need to set IAAS (e.g. vsphere or aws)"}
: ${INITIAL_FOUNDATION?"Need to set INITIAL_FOUNDATION"}

versionfile="${iaas_dir}/${INITIAL_FOUNDATION}/config/versions/$product.yml"
if [ ! -f ${versionfile} ]; then
  echo "Must create ${versionfile}"
  exit 1
fi
echo "Generating configuration for product"
echo "${versionfile}"

version=$(bosh interpolate ${versionfile} --path /product-version)
glob=$(bosh interpolate ${versionfile} --path /pivnet-file-glob)
slug=$(bosh interpolate ${versionfile} --path /pivnet-product-slug)

tile_config_dir=${repo_dir}/tile-configs/${product}-config
mkdir -p ${tile_config_dir}

## Check om version, due to command argument changes as well as config-template output changes
case $om_version in
  [1]*)
    echo "WARNING: this version of om generates very different defaults"
    exit 1
    # om_args="--output-directory=${tile_config_dir} --pivnet-api-token ${PIVNET_TOKEN} --pivnet-product-slug  ${slug} --product-version ${version} --product-file-glob ${glob}"
    ;;
  3.2.2)
    om_args="--output-directory=${tile_config_dir} --pivnet-api-token ${PIVNET_TOKEN} --pivnet-product-slug  ${slug} --product-version ${version} --product-file-glob ${glob}"
    ;;
  [4]*)
    om_args="--output-directory=${tile_config_dir} --pivnet-api-token ${PIVNET_TOKEN} --pivnet-product-slug  ${slug} --product-version ${version} --pivnet-file-glob ${glob}"
    ;;
  *)
    echo "Caution: Running unknown version of om"
    exit 1
esac

om config-template ${om_args}
scrubbedversion=$(cut -d'-' -f1 <<< ${version})
wrkdir=$(find ${tile_config_dir}/${product} -name "${scrubbedversion}*")
if [ ! -f ${wrkdir}/product.yml ]; then
  echo "Something wrong with configuration as expecting ${wrkdir}/product.yml to exist"
  exit 1
fi

ops_dir="${INITIAL_FOUNDATION}/ops-files"
mkdir -p ${ops_dir}
ops_files="${ops_dir}/${product}-operations"
touch ${ops_files}

ops_files_args=("")
while IFS= read -r var
do
  ops_files_args+=("-o ${wrkdir}/${var}")
done < "$ops_files"
bosh int ${wrkdir}/product.yml ${ops_files_args[@]} > ${INITIAL_FOUNDATION}/config/templates/${product}.yml

mkdir -p ${INITIAL_FOUNDATION}/config/defaults
rm -rf ${INITIAL_FOUNDATION}/config/defaults/${product}.yml
touch ${INITIAL_FOUNDATION}/config/defaults/${product}.yml
if [ -f ${wrkdir}/default-vars.yml ]; then
  echo "#### Default Product Variables ####" >> ${INITIAL_FOUNDATION}/config/defaults/${product}.yml
  cat ${wrkdir}/default-vars.yml >> ${INITIAL_FOUNDATION}/config/defaults/${product}.yml
else
  echo "WARNING: default vars missing from product"
  exit 1
fi
if [ -f ${wrkdir}/errand-vars.yml ]; then
  echo "#### Default Errand Variables ####" >> ${INITIAL_FOUNDATION}/config/defaults/${product}.yml
  cat ${wrkdir}/errand-vars.yml >> ${INITIAL_FOUNDATION}/config/defaults/${product}.yml
fi
if [ -f ${wrkdir}/resource-vars.yml ]; then
  echo "#### Default Resource Variables ####" >> ${INITIAL_FOUNDATION}/config/defaults/${product}.yml
  cat ${wrkdir}/resource-vars.yml >> ${INITIAL_FOUNDATION}/config/defaults/${product}.yml
fi
