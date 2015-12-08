#!/bin/echo Warning: this library should be sourced!
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

# action : checking whether the stratos server is ready to handle requests
# usage  : wait_until_ppaas_server_is_ready ${ppaas_ip} ${ppaas_port} ${ppaas_username} ${ppaas_password}
function wait_until_ppaas_server_is_ready() {
    until [ "$(curl --output /dev/null --silent --head --fail -X GET -H "Content-Type: application/json" --write-out '%{http_code}\n' -k -u $3:$4 https://$1:$2/api/init)" == "200" ]; do
      printf '.'
      sleep 5
    done
}

# action : display detailed usages of the script
# usage  : display_help
function display_help() {
    echo "Sorry, but no help"
}

# action : log if VERBOSE is set to true
# usage  : verbose_log ${string}
function verbose_log() {
    if [ "$VERBOSE" = true ]; then
       local date=`date +'%Y-%m-%d %H:%M:%S'`
       echo -e "[${date}] - $*";
    fi
}

# action : log
# usage  : log ${string}
function info_log() { 
    local date=`date +'%Y-%m-%d %H:%M:%S'`
    echo -e "[${date}] - $*";
}

# action : log without new line
# usage  : log ${string}
function info_log_n() { 
    local date=`date +'%Y-%m-%d %H:%M:%S'`
    echo -e -n "[${date}] - $*";
}

# action : overwrite a property value in the given file
# usage  : overwrite_property_value_in_file ${key} ${value} ${file}
function overwrite_property_value_in_file() {
    verbose_log "Setting value $2 for property $1 in file $3"
    sed -i "s/\($1 *= *\).*/\1$2/" $3
}

# action : list ip addresses
# usage  : list_ip_addresses
function list_ip_addresses() {
    ifconfig | awk '/inet addr/{print substr($2,6)}'
}

# action : prompt for user input if $3 is not set
# usage  : read_user_input ${prompt_message} "" ${variable_to_check_whether_set_or_not}
function read_user_input() {
    if [[ "$3" = "" ]] ; then
        read $2 -p "$1" user_input
        echo -n ${user_input}
    else
        echo $3
    fi
}

# action : read uncommented key-value pairs from the given file and declare them as variables
# usage  : declare_variables_from_file ${file}
function declare_variables_from_file {
    while read -r line
        do
            [[ "$line" =~ ^#.*$ ]] && continue
            declare  ${line}
        done < $1
}