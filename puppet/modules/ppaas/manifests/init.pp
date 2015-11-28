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
# Class: ppaas
#
# Actions:
#   - Install wso2 private paas
#

class ppaas (
  $version            = '4.1.0',
  $offset             = 0,
  $maintenance_mode   = true,
  $owner              = 'root',
  $group              = 'root',
  $target             = '/mnt',
) inherits params {

  $deployment_code = 'ppaas'
  $carbon_version  = $version
  $service_code    = 'ppaas'
  $carbon_home     = "${target}/wso2${service_code}-${carbon_version}"

  $service_templates = [
#    'conf/user-mgt.xml',
#    'conf/tenant-mgt.xml',
    'conf/cloud-controller.xml',
    'conf/datasources/master-datasources.xml',
#    'conf/datasources/ppaas-datasources.xml',
    'conf/jndi.properties',
    'conf/cartridge-config.properties',
    'conf/registry.xml',
    'conf/thrift-client-config.xml',
    'deployment/server/jaggeryapps/console/controllers/menu/menu.json'
  ]

  tag($service_code)

  ppaas::clean { $deployment_code:
    mode   => $maintenance_mode,
    target => $carbon_home,
  }

  ppaas::initialize { $deployment_code:
    repo      => $package_repo,
    version   => $carbon_version,
    service   => $service_code,
    local_dir => $local_package_dir,
    target    => $target,
    mode      => $maintenance_mode,
    owner     => $owner,
    require   => Clean[$deployment_code],
  }

  ppaas::deploy { $deployment_code:
    service  => $deployment_code,
    security => true,
    owner    => $owner,
    group    => $group,
    target   => $carbon_home,
    require  => Initialize[$deployment_code],
  }

  ppaas::push_templates {
    $service_templates:
      target    => $carbon_home,
      directory => 'ppaas',
      require   => Deploy[$deployment_code];
  }

  file { "/etc/init.d/wso2${service_code}":
    ensure    => present,
    owner     => 'root',
    group     => 'root',
    mode      => '0775',
    content   => template("${deployment_code}/wso2${service_code}.erb"),
  }

  file { "${carbon_home}/bin/wso2server.sh":
    ensure    => present,
    owner     => $owner,
    group     => $group,
    mode      => '0755',
    content   => template("${deployment_code}/wso2server.sh.erb"),
    require   => Deploy[$deployment_code],
    notify    => Service["wso2${service_code}"],
  }

  service { "wso2${service_code}":
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    require    => [
          Initialize[$deployment_code],
          Deploy[$deployment_code],
          Push_templates[$service_templates],
          File["${carbon_home}/bin/wso2server.sh"],
          File["/etc/init.d/wso2${service_code}"],
    ]   
  }
}
