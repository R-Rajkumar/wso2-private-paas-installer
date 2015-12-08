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

# installation variables
VERBOSE=false
PROFILE="default"

# exporting installation constants as environment variables
export INSTALLER_PATH
export SCRIPTS_PATH
export PACKS_PATH
export CONF_PATH

source ${SCRIPTS_PATH}/config.sh
source ${SCRIPTS_PATH}/functions.sh

info_log "Cleaning started"

# parsing command line arguments
while [[ $# > 0 ]]
do
key="$1"
case ${key} in
    -h|--help)
     display_help
     exit 0
    ;;
    -d|--verbose)
     VERBOSE=true
    ;;
    -p|--profile)
     PROFILE="$2"
     shift
    ;;
    *)
     # unknown argument ; ignore it
    ;;
esac
shift
done

# exporting VERBOSE as environment variable
export VERBOSE

verbose_log "Positional parameters [--profile] ${PROFILE} [--verbose] ${VERBOSE}"

[ "$PROFILE" = "ppaas" ] && {

while true; do
   info_log_n  "Do you want to destroy private paas installation? [Y/N] "
   read answer
   answer=`echo ${answer} | tr [a-z] [A-Z]`
   case ${answer} in
        Y) 
         # destroying wso2 private paas
         ${SCRIPTS_PATH}/destroy_ppaas.sh
         break
        ;;
        N) 
         break
        ;;
        *) 
         info_log "Please answer Y or N "
        ;;
   esac
done

while true; do
   info_log_n  "Do you want to destroy activemq installation? [Y/N] "
   read answer
   answer=`echo ${answer} | tr [a-z] [A-Z]`
   case ${answer} in
        Y) 
         # destroying activemq
         ${SCRIPTS_PATH}/destroy_activemq.sh
         break
        ;;
        N) 
         break
        ;;
        *) 
         info_log "Please answer Y or N "
        ;;
   esac
done

}

[ "$PROFILE" = "activemq" ] && {
  while true; do
     info_log_n  "Do you want to destroy activemq installation? [Y/N] "
     read answer
     answer=`echo ${answer} | tr [a-z] [A-Z]`
     case ${answer} in
          Y) 
           # destroying activemq
           ${SCRIPTS_PATH}/destroy_activemq.sh
           break
          ;;
          N) 
           break
          ;;
          *) 
           info_log "Please answer Y or N "
          ;;
     esac
  done
}

info_log "Cleaning completed successfully"
