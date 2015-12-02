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

class activemq::package {

  file {
    $local_package_dir:
      ensure => directory;

    $activemq::base_dir:
      ensure => directory,
      owner  => $activemq::owner,
      group  => $activemq::group;

    "${local_package_dir}/${activemq::package}":
      ensure  => present,
      source  => "puppet:///modules/activemq/${activemq::package}",
      require => File[$local_package_dir];
  }

  exec {
    "Extract ${activemq::package}":
      path    => '/opt/java/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      cwd     => $activemq::base_dir,
      unless  => "test -d ${activemq::activemq_home}/conf",
      command => "tar xvfz ${local_package_dir}/${activemq::package}",
      creates => "${activemq::activemq_home}/conf",
      require =>  [
        File["${local_package_dir}/${activemq::package}"],
        File[$activemq::base_dir],
        ];

    "Setting permission for activemq":
      path      => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      cwd       => $activemq::base_dir,
      command   => "chown -R ${activemq::owner}:${activemq::group} ${activemq::activemq_home};
                    chmod -R 755 ${activemq::activemq_home}",
      logoutput => 'on_failure',
      timeout   => 0,
      require   => Exec["Extract ${activemq::package}"];
  }
}
