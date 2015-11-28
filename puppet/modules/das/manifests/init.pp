#----------------------------------------------------------------------------
#  Copyright 2005-2013 WSO2, Inc. http://www.wso2.org
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
#----------------------------------------------------------------------------
#
# Class: as
#
# This class installs WSO2 AS
#
# Parameters:
#
# Actions:
#   - Install WSO2 AS
#
# Requires:
#
# Sample Usage:
#

class das (
  $version               = undef,
  $offset                = 0,
  $das_subdomain         = "das",
  $clustering_port       = '4000',
  $config_db             = governance,
  $depsync               = false,
  $sub_cluster_domain    = mgt,
  $clustering            = false,
  $members               = {},
  $owner                 = root,
  $group                 = root,
  $target                = '/mnt',
  $monitoring            = false
) inherits das::params {

  $deployment_code       = 'das'
  $service_code          = 'das'
  $carbon_version        = $version
  $carbon_home           = "${target}/wso2${service_code}-${carbon_version}"
  $das_symlink           = '/mnt/wso2das/'

  $service_templates  = [ 
    'conf/analytics/analytics-data-config.xml',
    'conf/analytics/spark/spark-defaults.conf',
    'conf/axis2/axis2.xml',
    'conf/carbon.xml',
    'conf/datasources/analytics-datasources.xml',
    'conf/datasources/das-datasources.xml',
    'conf/jndi.properties',
  ]

  $common_templates   = [ 
    'conf/user-mgt.xml',
    'conf/registry.xml',
    'conf/tenant-mgt.xml',
    'conf/datasources/master-datasources.xml',
  ]

  tag('das')

  das::clean { $deployment_code:
    mode   => $maintenance_mode,
    target => $carbon_home;
  }

  das::initialize { $deployment_code:
    repo             => $package_repo,
    version          => $version,
    mode   		       => $maintenance_mode,
    service   		   => $service_code,
    deployment_code	 => $deployment_code,
    local_dir 		   => $local_package_dir,
    owner        		 => $owner,
    target   	    	 => $target,
    require 		     => Clean[$deployment_code];
  }


  das::deploy { $deployment_code:
    security 		 => true,
    owner    		 => $owner,
    group    		 => $group,
    target   		 => $carbon_home,
    require  		 => Initialize[$deployment_code];
  }

  das::push_templates { 
    $service_templates: 
      target    => $carbon_home,
      directory => $deployment_code,
      require   => Deploy[$deployment_code];

    $common_templates:
      target    => $carbon_home,
      directory => 'wso2base',
      require   => Deploy[$deployment_code],
  }

  file { "${carbon_home}/bin/wso2server.sh":
    ensure  => present,
    owner   => $owner,
    group   => $group,
    mode    => '0755',
    content => template("${deployment_code}/wso2server.sh.erb"),
    require => Deploy[$deployment_code],
    #    notify  => Service["wso2${service_code}"],
  }

  file { $das_symlink:
    ensure => link,
    target => $carbon_home
  }

  file { "/etc/init.d/wso2${service_code}":
    ensure  		 => present,
    owner   		 => $owner,
    group   		 => $group,
    mode    		 => '0775',
    content 		 => template("${deployment_code}/wso2${service_code}.erb"),
    require 		 => Deploy[$deployment_code],
  }

 
  #  service { "wso2${service_code}":
  #    ensure   		 => running,
  #    hasstatus  		 => true,
  #    hasrestart 		 => true,
  #    enable   		 => true,
  #    require    		 => [
  #        Initialize[$deployment_code],
  #        Deploy[$deployment_code],
  #        Push_templates[$service_templates],
  #        File["${carbon_home}/bin/wso2server.sh"],
  #        File["/etc/init.d/wso2${service_code}"],
  #
  #      ]
  #  }
}

