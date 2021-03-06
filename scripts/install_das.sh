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

info_log "Private paas installation started"
verbose_log "Executing $0"

info_log "Listing available ip address of the machine \n$(list_ip_addresses)"
info_log_n  "Please select one of the above ip address to run private paas with or press enter keep the default value ${FACTER_ppaas_host_ip} : "
read machine_ip

if [[ -z "$machine_ip" ]];
then
  verbose_log "You have selected the default value ${FACTER_ppaas_host_ip} as private paas ip"
elif [[ ! -z "$machine_ip" ]] && [[ $(list_ip_addresses) == *"${machine_ip}"* ]];
then
  verbose_log "You entered ${machine_ip} as private paas ip"
  overwrite_property_value_in_file "FACTER_ppaas_host_ip" "$machine_ip" "${CONF_PATH}/setup.conf"
else
  verbose_log "You entered ${machine_ip} as private paas ip"
  info_log "Entered ip is not available in this machine, proceeding with 127.0.0.1"
  overwrite_property_value_in_file "FACTER_ppaas_host_ip" "127.0.0.1" "${CONF_PATH}/setup.conf"
fi

if [[ ${FACTER_ppaas_offset} -ge 0 ]];
then
  info_log_n  "Please enter private paas port offset or press enter to keep the default value $FACTER_ppaas_offset : "
else
  info_log_n  "Please enter private paas port offset : "
fi

read ppaas_offset
verbose_log "You entered ${ppaas_offset} as private paas port offset"

[[ ! -z ${ppaas_offset} ]] && [[ ${ppaas_offset}  =~ ^-?[0-9]+$ ]] && [[ ${ppaas_offset}  -ge 0 ]] && {
  overwrite_property_value_in_file "FACTER_ppaas_offset" $ppaas_offset "${CONF_PATH}/setup.conf"
  overwrite_property_value_in_file "FACTER_ppaas_host_port" $((${FACTER_ppaas_host_port} + ${ppaas_offset})) "${CONF_PATH}/setup.conf"
}

if [[ -z "$FACTER_mb_url" ]];
 then
  info_log_n  "Please enter message broker amqp url : "
 else
  info_log_n  "Please enter message broker amqp url or press enter to keep the default value $FACTER_mb_url : "
fi

read mb_amqp_url

if [[ -z "$mb_amqp_url" ]] && [[ -z "$FACTER_mb_url" ]];
then
  info_log "Entered message broker amqp url is not valid, proceeding with tcp://localhost:61616"
  overwrite_property_value_in_file "FACTER_mb_url" "tcp://localhost:61616" "${CONF_PATH}/setup.conf"
elif [[ -z "$mb_amqp_url" ]] && [[ ! -z "$FACTER_mb_url" ]];
then
  verbose_log "You have selected the default value ${FACTER_mb_url} as message broker amqp url"
elif [[ ! -z "$mb_amqp_url" ]];
then
  verbose_log "You entered ${mb_amqp_url} as message broker amqp url"
  overwrite_property_value_in_file "FACTER_mb_url" "$mb_amqp_url" "${CONF_PATH}/setup.conf"
fi

# overriding default environment variables before running puppet apply
source ${CONF_PATH}/setup.conf

# firing a puppet apply command to install wso2 private paas
verbose_log "Running ${RUN_PUPPET_APPLY} --modulepath=${FACTER_puppet_modules_path} -e \"include ppaas\""
${RUN_PUPPET_APPLY} --modulepath=${FACTER_puppet_modules_path} -e "include ppaas"

verbose_log "Starting server on [host] ${FACTER_ppaas_host_ip} [port] ${FACTER_ppaas_host_port}"

# waiting for wso2 private paas to become active
info_log_n "Waiting for private paas server to become active"
wait_until_ppaas_server_is_ready ${FACTER_ppaas_host_ip} ${FACTER_ppaas_host_port} ${FACTER_ppaas_username} ${FACTER_ppaas_password}

echo ""
info_log "Private paas installation completed successfully"
