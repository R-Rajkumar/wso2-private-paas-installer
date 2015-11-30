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


# checking whether the stratos server is ready to handle requests
# usage : 
#         is_server_active <stratos_ip> <stratos_port>
function is_ppaas_server_active() {
    until $(curl --output /dev/null --silent --head --fail -X GET -H "Content-Type: application/json" -k -u admin:admin https://$1:$2/api/init); do
      printf '.'
      sleep 5
    done
}

function display_help() {
    echo "Help is on the way..."
}
