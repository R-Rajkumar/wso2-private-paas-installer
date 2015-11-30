#!/bin/bash
# ----------------------------------------------------------------------------
#  Copyright 2005-2015 WSO2, Inc. http://www.wso2.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# ----------------------------------------------------------------------------

set -o errexit
set -o nounset

CURRENT_DIR=$(dirname $0)
INSTALLER_PATH=`cd $CURRENT_DIR;pwd`
SCRIPTS_PATH=${INSTALLER_PATH}/scripts
PACKS_PATH=${INSTALLER_PATH}/packs
PUPPET=`which puppet`
PUPPETAPPLY="${PUPPET} apply"
PUPPETAGENT="${PUPPET} agent"
RUNPUPPETAPPLY="${PUPPETAPPLY}"
RUNPUPPETAGENT="${PUPPETAGENT} -vt"
PPAAS_HOST_IP="localhost"
PPAAS_HOST_PORT=9443

source ${SCRIPTS_PATH}/functions.sh

# parsing command line arguments
while [[ $# > 1 ]]
do
key="$1"

case $key in
    -h|--help)
    display_help
    exit 0
    ;;
    -p|--profile)
    EXTENSION="$2"
    shift
    ;;
    -c|--clean)
    CLEAN="$2"
    ;;
    -l|--lib)
    LIBPATH="$2"
    shift
    ;;
    --default)
    DEFAULT=YES
    ;;
    *)
          # unknown option
    ;;
esac
shift
done

echo FILE EXTENSION  = "${EXTENSION}"
echo SEARCH PATH     = "${SEARCHPATH}"

echo "Starting WSO2 PPAAS..."
${RUNPUPPETAPPLY} --modulepath=puppet/modules/ -e "include ppaas"

echo -n "Waiting for wso2 private paas to become active"
is_ppaas_server_active ${PPAAS_HOST_IP} ${PPAAS_HOST_PORT}

echo -e "\nInstallation completed successfully"

