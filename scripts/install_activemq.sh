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
source ${CONF_PATH}/setup.conf

info_log "ActiveMQ installation started"
verbose_log "Executing $0"

# overriding default environment variables
source ${CONF_PATH}/setup.conf

# firing a puppet apply command to install activemq
verbose_log "Running ${RUN_PUPPET_APPLY} --modulepath=${FACTER_puppet_modules_path} -e \"include activemq\""
${RUN_PUPPET_APPLY} --modulepath=${FACTER_puppet_modules_path} -e "include activemq"

info_log "ActiveMQ installation completed successfully"
