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

class activemq::config {

  file {
    "${activemq::activemq_home}/conf/activemq.xml":
      ensure  => present,
      content => template('activemq/activemq.xml.erb'),
      owner  => $activemq::owner,
      group  => $activemq::group,
      require => Exec["Extract ${activemq::package}"];

    "${activemq::activemq_home}/lib/mysql-connector-java-5.1.37-bin.jar":
      ensure  => present,
      source  => 'puppet:///modules/activemq/mysql-connector-java-5.1.37-bin.jar',
      owner   => $activemq::owner,
      group   => $activemq::group,
      mode    => '0777',
      require => Exec["Extract ${activemq::package}"];
  }

  file { '/etc/init.d/activemq':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('activemq/activemq.init.erb');
  }
}
