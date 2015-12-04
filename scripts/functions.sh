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
# usage  : is_server_active ${stratos_ip} ${stratos_port}
function wait_until_ppaas_server_is_ready() {
    until $(curl --output /dev/null --silent --head --fail -X GET -H "Content-Type: application/json" -k -u admin:admin https://$1:$2/api/init); do
      printf '.'
      sleep 5
    done
}

# action : display detailed usages of the script
# usage  : display_help
function display_help() {
    echo "Sorry, but no help"
}

# action : log if DEBUG_LOG is set to 1
# usage  : debug ${string}
function debug_log() { 
    if [ "$DEBUG_LOG" = true ]; then 
       local datestring=`date +'%Y-%m-%d %H:%M:%S'`
       echo -e "[${datestring}] DEBUG - $*"; 
    fi
}

# action : log
# usage  : log ${string}
function info_log() { 
    local datestring=`date +'%Y-%m-%d %H:%M:%S'`
    echo -e "[${datestring}] INFO - $*"; 
}

# action : log without new line
# usage  : log ${string}
function info_log_n() { 
    local datestring=`date +'%Y-%m-%d %H:%M:%S'`
    echo -e -n "[${datestring}] INFO - $*"; 
}
