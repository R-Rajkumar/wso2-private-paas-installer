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

# installation constants
CURRENT_DIR=$(dirname $0)
INSTALLER_PATH=`cd ${CURRENT_DIR};pwd`
SCRIPTS_PATH=${INSTALLER_PATH}/scripts
PACKS_PATH=${INSTALLER_PATH}/packs
CONF_PATH=${INSTALLER_PATH}/conf
SETUP_CONF_FILE="${CONF_PATH}/setup.conf"

# installation variables
VERBOSE=false
PROFILE="default"
CLEAN=false

# exporting installation constants as environment variables
export INSTALLER_PATH
export SCRIPTS_PATH
export PACKS_PATH
export CONF_PATH
export SETUP_CONF_FILE

source ${SCRIPTS_PATH}/config.sh
source ${SCRIPTS_PATH}/functions.sh

info_log "Installation started"

# parsing command line arguments
while [[ $# > 0 ]]
do
key="$1"
case ${key} in
    -h|--help)
     display_help
     exit 0
    ;;
    -v|--verbose)
     VERBOSE=true
    ;;
    -p|--profile)
     PROFILE="$2"
     shift
    ;;
    -c|--clean)
     CLEAN=true
    ;;
    *)
     # unknown argument ; ignore it
    ;;
esac
shift
done

# Make sure the user is running as root.
if [ "$UID" -ne "0" ]; then
  info_log "Need root access. Run the script $0 as 'root' or with 'sudo' permissions"
  exit 69
fi

# exporting VERBOSE as environment variable
export VERBOSE

verbose_log "Positional parameters [--profile] ${PROFILE} [--verbose] ${VERBOSE} [--clean] ${CLEAN}"

[ "$PROFILE" = "ppaas" ] && [ "$CLEAN" = false ] && {
   # starting wso2 private paas
   ${SCRIPTS_PATH}/install_ppaas.sh
}

[ "$PROFILE" = "activemq" ] && [ "$CLEAN" = false ] && {
   # starting activemq
   ${SCRIPTS_PATH}/install_activemq.sh
}

[ "$PROFILE" = "puppet" ] && [ "$CLEAN" = false ] && {
   # starting activemq
   args=("-m" "-d${stratos_domain}")
   ${SCRIPTS_PATH}/install_puppet.sh "${args[@]}"
}

info_log "Installation completed successfully"
