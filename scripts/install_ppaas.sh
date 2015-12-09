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

info_log "Private paas installation started"
verbose_log "Executing $0"

info_log "Listing available ip address of the machine \n$(list_ip_addresses)"
default_ppaas_host_ip=$(read_property "ppaas_host_ip" ${SETUP_CONF_FILE})
ppaas_host_ip=$(read_user_input  "Please select one of the above ip address to run private paas with : " "" ${default_ppaas_host_ip})
verbose_log "You have chosen ${ppaas_host_ip} as private paas ip"

if [[ "$default_ppaas_host_ip" != "$ppaas_host_ip" ]]; then
    if [[ ! -z "$ppaas_host_ip" ]] && [[ $(list_ip_addresses) == *"${ppaas_host_ip}"* ]];
    then
        overwrite_property_value_in_file "ppaas_host_ip" "$ppaas_host_ip" ${SETUP_CONF_FILE}
    else
        info_log "Chosen ip ${ppaas_host_ip} is not available in this machine, proceeding with 127.0.0.1"
        overwrite_property_value_in_file "ppaas_host_ip" "127.0.0.1" ${SETUP_CONF_FILE}
    fi
fi

default_ppaas_offset=$(read_property "ppaas_offset" ${SETUP_CONF_FILE})
ppaas_offset=$(read_user_input  "Please enter private paas port offset : " "" ${default_ppaas_offset})
verbose_log "You have chosen ${ppaas_offset} as private paas port offset"

[[ ! -z ${ppaas_offset} ]] && [[ ${ppaas_offset}  =~ ^-?[0-9]+$ ]] && [[ ${ppaas_offset}  -ge 0 ]] && [[ "$default_ppaas_offset" != "$ppaas_offset" ]] &&{
  overwrite_property_value_in_file "ppaas_offset" $ppaas_offset ${SETUP_CONF_FILE}
  ppaas_host_port=$(read_property "ppaas_host_port" ${SETUP_CONF_FILE})
  overwrite_property_value_in_file "ppaas_host_port" $((${ppaas_host_port} + ${ppaas_offset})) ${SETUP_CONF_FILE}
}

default_mb_ip=$(read_property "mb_ip" ${SETUP_CONF_FILE})
mb_ip=$(read_user_input  "Please enter message broker ip : " "" ${default_mb_ip})
verbose_log "You have chosen ${mb_ip} as message broker ip"

if [[ -z "$mb_ip" ]];
then
  info_log "Chosen message broker ip is not valid, proceeding with localhost"
  overwrite_property_value_in_file "mb_ip" "localhost" ${SETUP_CONF_FILE}
elif [[ "$mb_ip" != "$default_mb_ip" ]]
then
  overwrite_property_value_in_file "mb_ip" "$mb_ip" ${SETUP_CONF_FILE}
fi

default_mb_port=$(read_property "mb_port" ${SETUP_CONF_FILE})
mb_port=$(read_user_input  "Please enter message broker port : " "" ${default_mb_port})
verbose_log "You have chosen ${mb_port} as message broker port"

if [[ -z "$mb_port" ]];
then
  info_log "Chosen message broker port is not valid, proceeding with 61616"
  overwrite_property_value_in_file "mb_port" "61616" ${SETUP_CONF_FILE}
elif [[ "$mb_port" != "$default_mb_port" ]]
then
  overwrite_property_value_in_file "mb_port" "$mb_port" ${SETUP_CONF_FILE}
fi

# exporting facter variables before calling puppet apply
export_variables_from_file_as_facter_variables ${SETUP_CONF_FILE}
export_variables_from_file ${SETUP_CONF_FILE}
echo $mb_ip;
echo $mb_port;
echo $mb_url;

exit;

# firing a puppet apply command to install wso2 private paas
verbose_log "Running ${RUN_PUPPET_APPLY} --modulepath=${FACTER_puppet_modules_path} -e \"include ppaas\""
${RUN_PUPPET_APPLY} --modulepath=${FACTER_puppet_modules_path} -e "include ppaas"

verbose_log "Starting server on [host] ${FACTER_ppaas_host_ip} [port] ${FACTER_ppaas_host_port}"

# waiting for wso2 private paas to become active
info_log_n "Waiting for private paas server to become active"
wait_until_ppaas_server_is_ready ${FACTER_ppaas_host_ip} ${FACTER_ppaas_host_port} ${FACTER_ppaas_username} ${FACTER_ppaas_password}

echo ""
info_log "Private paas installation completed successfully"
