# ----------------------------------------------------------------------------
#  Copyright 2005-2015 WSO2, Inc. http://www.wso2.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file exppaast in compliance with the License.
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
#

class activemq(
  $version    	     = '5.12.1',
  $base_dir          = '/mnt',
  $owner             = 'root',
  $group             = 'root',
  $webconsole        = false,
) {

  $local_package_dir = "${base_dir}/packs"
  $package       = "apache-activemq-${version}-bin.tar.gz"
  $activemq_home = "${base_dir}/apache-activemq-${version}"

  class { 'activemq::package': }

  class { 'activemq::config':
    notify => Class['activemq::service'],
  }

  class { 'activemq::service':
    require => Class['activemq::package'],
  }
}
