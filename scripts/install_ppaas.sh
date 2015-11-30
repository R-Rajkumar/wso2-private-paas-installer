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

# action : install wso2 private paas using puppet apply or master/agent

echo "INFO : Starting WSO2 PPAAS installation..."

source ${SCRIPTS_PATH}/config.sh
source ${SCRIPTS_PATH}/functions.sh

# firing a puppet apply command to install wso2 private paas
${RUN_PUPPET_APPLY} --modulepath=${PUPPET_MODULES_PATH} -e "include ppaas"

# waiting for wso2 private paas to become active
echo -n "INFO : Waiting for wso2 private paas to become active"
is_ppaas_server_active ${PPAAS_HOST_IP} ${PPAAS_HOST_PORT}

echo -e "\nINFO : WSO2 Private PaaS installation completed successfully"
