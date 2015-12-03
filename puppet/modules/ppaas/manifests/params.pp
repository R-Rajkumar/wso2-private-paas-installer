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
# Class ppaas::params
#
# This class manages ppaas parameters
#
# Parameters:
#
# Usage: Uncomment the variable and assign a value to override the wso2.pp value
#
#

class ppaas::params {

$local_package_dir='/mnt/${server_ip}/packs'

# ppaas conf
#PPAAS_HOST_IP="localhost"
#PPAAS_HOST_PORT=9443

# autoscaler.xml
#cc_host_name="localhost"
#cc_port=9443
#cc_client_timeout=300000
#sm_host_name="localhost"
#sm_port=9443
#sm_client_timeout=300000
#identity_host_name="localhost"
#identity_port=9443
#identity_client_timeout=300000
#member_spin_after_terminate=false
#pending_member_expiry_timeout=900000
#obsoleted_member_expiry_timeout=86400000
#pending_termination_member_expiry_timeout=1800000
#cluster_monitoring_interval=90000

# carbon.xml
#ppaas_offset=0

# cartridge-config.properties
#autoscaler_service_url="https://localhost:9443/services/AutoscalerService/"
#cloud_controller_service_url="https://localhost:9443/services/CloudControllerService/"
#stratos_manager_service_url="https://localhost:9443/services/StratosManagerService/"
#das_metering_dashboard_url="https://localhost:9444/portal/dashboards/ppaas-metering-dashboard"
#puppet_ip="127.0.0.1"
#puppet_hostname="puppet.apache.stratos.org"
#puppet_dns_available=false
#puppet_environment="stratos"

# cloud-controller.xml 
#openstack_iaas_enabled=false
#openstack_class="org.apache.stratos.cloud.controller.iaases.openstack.OpenstackIaas"
#openstack_provider="openstack-nova"
#openstack_identity="project:username"
#openstack_credential="credential"
#openstack_jclouds_endpoint="http://192.168.16.99:5000/v2.0"
#openstack_jclouds_openstack_nova_auto_create_floating_ips=false
#openstack_jclouds_api_version="2.0/"
#openstack_networking_provider="nova"
#openstack_keyPair="keypair-name"
#openstack_security_groups="default"
#ec2_iaas_enabled="false"
#ec2_class="org.apache.stratos.cloud.controller.iaases.ec2.EC2Iaas"
#ec2_provider="aws-ec2"
#ec2_identity="identity"
#ec2_credential="credential"
#ec2_jclouds_ec2_ami_query="owner-id=owner-id;state=available;image-type=machine"
#ec2_availability_Zone="ap-southeast-1b"
#ec2_security_groups="default"
#ec2_auto_assign_ip="true"
#ec2_keyPair="keypair-name"
#kubernetes_iaas_enabled=true
#kubernetes_class="org.apache.stratos.cloud.controller.iaases.kubernetes.KubernetesIaas"
#kubernetes_provider="kubernetes"
#kubernetes_identity="identity"
#kubernetes_credential="credential"
#mock_iaas_enabled=true
#mock_class="org.apache.stratos.cloud.controller.iaases.mock.MockIaas"
#mock_provider="mock"
#mock_identity="identity"
#mock_credential="credential"
#mock_api_endpoint="https://localhost:9443/mock-iaas/api"

# jndi.properties
#mb_url="tcp://localhost:61616"

# mock-iaas.xml
#mock_iaas_enabled=true

# mqtttopic.properties
#mqtturl="tcp://localhost:1883"

# registry.xml / master-datasources.xml / user-mgt.xml
#export FACTER_gov_db=""
#export FACTER_gov_db_data_source=""
#export FACTER_gov_db_remote_instance_url=""
#export FACTER_gov_db_username=""
#export FACTER_gov_db_password=""
#export FACTER_gov_db_driver_class="com.mysql.jdbc.Driver"
#export FACTER_gov_db_max_active="150"
#export FACTER_gov_db_max_wait="60000"
#export FACTER_gov_db_min_idle="50"
#export FACTER_ppaas_config_db=""
#export FACTER_ppaas_config_db_data_source=""
#export FACTER_ppaas_config_db_remote_instance_url=""
#export FACTER_ppaas_config_db_username=""
#export FACTER_ppaas_config_db_password=""
#export FACTER_ppaas_config_db_driver_class="com.mysql.jdbc.Driver"
#export FACTER_ppaas_config_db_max_active="150"
#export FACTER_ppaas_config_db_max_wait="60000"
#export FACTER_ppaas_config_db_min_idle="50"
#export FACTER_user_db=""
#export FACTER_user_db_data_source=""
#export FACTER_user_db_username=""
#export FACTER_user_db_password=""
#export FACTER_user_db_driver_class="com.mysql.jdbc.Driver"
#export FACTER_user_db_max_active="150"
#export FACTER_user_db_max_wait="60000"
#export FACTER_user_db_min_idle="50"

# thrift-client-config.xml
#cep_stats_publisher_enabled=true
#cep_username="admin"
#cep_password="admin"
#cep_ip="localhost"
#cep_port="7611"
#das_stats_publisher_enabled=false
#das_username="admin"
#das_password="admin"
#das_ip="localhost"
#das_port="7612"

# puppet conf
#PUPPET_MASTER_IP=localhost
#PUPPET_MASTER_HOST_NAME=puppet.wso2.org
#PUPPET_MODULES_PATH=${INSTALLER_PATH}/puppet/modules
}
