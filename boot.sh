#!/bin/bash
# ----------------------------------------------------------------------------
#  Copyright 2005-2013 WSO2, Inc. http://www.wso2.org
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

CURRENT_DIR=$(dirname $0)
INSTALLER_PATH=`cd $CURRENT_DIR;pwd`
SCRIPTS_PATH=${INSTALLER_PATH}/scripts
PACKS_PATH=${INSTALLER_PATH}/packs
PUPPET=`which puppet`
PUPPETAPPLY="${PUPPET} apply"
PUPPETAGENT="${PUPPET} agent"
RUNPUPPETAPPLY="${PUPPETAPPLY}"
RUNPUPPETAGENT="${PUPPETAGENT} -vt"
HOST_IP="localhost"
HOST_PORT=9443

echo "Starting WSO2 PPAAS..."
${RUNPUPPETAPPLY} --modulepath=puppet/modules/ -e "include ppaas"

echo -n "Waiting for wso2 private paas to become active"
until $(curl --output /dev/null --silent --head --fail -X GET -H "Content-Type: application/json" -k -u admin:admin https://${HOST_IP}:${HOST_PORT}/api/init); do
    printf '.'
    sleep 5
done

echo "Installation completed successfully"

