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

source ${SCRIPTS_PATH}/config.sh
source ${SCRIPTS_PATH}/functions.sh
source ${CONF_PATH}/default.conf

info_log "Private paas installation started"
debug_log "Executing $0"



# firing a puppet apply command to install wso2 private paas
debug_log "Running ${RUN_PUPPET_APPLY} --modulepath=${FACTER_puppet_modules_path} -e \"include ppaas\""
${RUN_PUPPET_APPLY} --modulepath=${FACTER_puppet_modules_path} -e "include ppaas"

debug_log "Starting server on [host] ${FACTER_ppaas_host_ip} [port] $((${FACTER_ppaas_host_port} + ${FACTER_ppaas_offset}))"

# waiting for wso2 private paas to become active
info_log_n "Waiting for private paas server to become active"
wait_until_ppaas_server_is_ready ${FACTER_ppaas_host_ip} $((${FACTER_ppaas_host_port} + ${FACTER_ppaas_offset})) ${FACTER_ppaas_username} ${FACTER_ppaas_password}

echo ""
info_log "Private paas installation completed successfully"
