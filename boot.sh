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
INSTALLER_PATH=`cd $CURRENT_DIR;pwd`
SCRIPTS_PATH=${INSTALLER_PATH}/scripts
PACKS_PATH=${INSTALLER_PATH}/packs
CONF_PATH=${INSTALLER_PATH}/conf

# installation variables
DEBUG_LOG=false
PROFILE="default"
CLEAN=false

# exporting installation constants as environment variables
export INSTALLER_PATH
export SCRIPTS_PATH
export PACKS_PATH
export CONF_PATH

source ${SCRIPTS_PATH}/config.sh
source ${SCRIPTS_PATH}/functions.sh

info_log "Installation started"

# parsing command line arguments
while [[ $# > 0 ]]
do
key="$1"
case $key in
    -h|--help)
     display_help
     exit 0
    ;;
    -d|--debug)
     DEBUG_LOG=true
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

# exporting DEBUG_LOG as environment variable
export DEBUG_LOG

debug_log "Positional parameters [--profile] ${PROFILE} [--debug] ${DEBUG_LOG} [--clean] ${CLEAN}"

[ "$PROFILE" = "ppaas" ] && [ "$CLEAN" = false ] && {
   # starting wso2 private paas
   $SCRIPTS_PATH/install_ppaas.sh
}

[ "$PROFILE" = "activemq" ] && [ "$CLEAN" = false ] && {
   # starting activemq
   $SCRIPTS_PATH/install_ppaas.sh
}


info_log "Installation completed successfully"
