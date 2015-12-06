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
source ${CONF_PATH}/setup.conf

info_log "Cleaning ActiveMQ installation"
debug_log "Executing $0"

info_log "Stopping private paas"
/etc/init.d/activemq stop

sudo rm -rf /mnt/apache-activemq-5.12.1/
sudo rm /mnt/packs/apache-activemq-5.12.1-bin.tar.gz

info_log "Cleaned ActiveMQ installation successfully"
