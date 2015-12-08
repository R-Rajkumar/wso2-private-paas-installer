#!/bin/bash

# Puppet Installer.
#
# Thilina Piyasundara
# 2014-02-12
# last updated on : 2014-02-12
#
#
# Copyright 2014 Thilina Piyasundara
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Exit on fail
set -e

# General commands
MV=`which mv` && : || (echo "Command 'mv' is not installed."; exit 10;)
CP=`which cp` && : || (echo "Command 'cp' is not installed."; exit 10;)
ID=`which id` && : || (echo "Command 'id' is not installed."; exit 10;)
CAT=`which cat` && : || (echo "Command 'cat' is not installed."; exit 10;)
CUT=`which cut` && : || (echo "Command 'cut' is not installed."; exit 10;)
AWK=`which awk` && : || (echo "Command 'awk' is not installed."; exit 10;)
SED=`which sed` && : || (echo "Command 'sed' is not installed."; exit 10;)
WGET=`which wget` && : || (echo "Command 'wget' is not installed."; exit 10;)
DATE=`which date` && : || (echo "Command 'date' is not installed."; exit 10;)
ECHO=`which echo` && : || (echo "Command 'echo' is not installed."; exit 10;)
UNAME=`which uname` && : || (echo "Command 'uname' is not installed."; exit 10;)
HOSTNAME=`which hostname` && : || (echo "Command 'hostname' is not installed."; exit 10;)

# Parameters
MASTER=0
VERBOSE=0
FORCEYES=0
MASTERIP=""
NODENAME=""
DOMAIN=""
OSDIST=""

# Execute bashtrap function when user press [Ctrl]+[c]
trap bashtrap INT

function print_usage(){
    ${ECHO} -e "Puppet Installer v1 2014-02-12"
    ${ECHO} -e "This script will install PuppetLab puppet v3."
    ${ECHO} -e "Thilina Piyasundara. <mail@thilina.org>"
    ${ECHO} -e ""
    ${ECHO} -e "Usage: "
    ${ECHO} -e "    puppetinstall -m|-n <node hostname> -d <domain>"
    ${ECHO} -e "            [-s <puppet master server ip>] [-t <timezone>] [-y]"
    ${ECHO} -e ""
    ${ECHO} -e "Commands:"
    ${ECHO} -e "Either long or short options are allowed."
    ${ECHO} -e "    -m              Install puppet master on the system."
    ${ECHO} -e "    -n <hostname>   Install puppet agent on the system."
    ${ECHO} -e "                    If you use -m tag with this, -n tag will be ignored."
    ${ECHO} -e "    -d <domain>     Domain name of the environment. This will act as a"
    ${ECHO} -e "                    prefix to all the servers of the domain."
    ${ECHO} -e "                    eg: "
    ${ECHO} -e "                    if a server is: server23.dc1.example.com"
    ${ECHO} -e "                    your domain must be : dc1.example.com"
    ${ECHO} -e "    -s <ip>         IP address of the puppet master server."
    ${ECHO} -e "                    This IP address will added to the /etc/hosts file."
    ${ECHO} -e "    -t <timezone>   This will set the system timezone. Default is Etc/UTC"
    ${ECHO} -e "                    eg: "
    ${ECHO} -e "                    For Sri Lanka use : Asia/Colombo"
    ${ECHO} -e "    -y              Forcefully accept the user confirmation."
    ${ECHO} -e "    -h              This will print this message."
    ${ECHO} -e "    -v              This will activate verbose mode."
    ${ECHO} -e ""
    ${ECHO} -e "Examples: "
    ${ECHO} -e "    sudo bash puppetinstall -m -d example.com"
    ${ECHO} -e "        This will install puppet master on example.com domain."
    ${ECHO} -e ""
    ${ECHO} -e "    sudo bash puppetinstall -n node001 -d example.com -s 192.168.122.1"
    ${ECHO} -e "        This will install puppet agent on example.com domain. "
    ${ECHO} -e "        Agent hostname will be node001.example.com and will point"
    ${ECHO} -e "        to the puppet master on 192.168.122.1 server."
    ${ECHO} -e ""
    ${ECHO} -e "Report bugs/issues on https://github.com/thilinapiy/puppetinstall/issues"
}

function print_message(){
    if [ ${VERBOSE} -eq 1 ]; then
        ${ECHO} -en $1
    fi
}

function print_ok(){
    if [ ${VERBOSE} -eq 1 ]; then
        ${ECHO} -e " [Done]"
    fi
}

function print_error(){
    if [ ${VERBOSE} -eq 1 ]; then
        ${ECHO} -e " [Error]\n"$1
    else
        ${ECHO} -e "[Error]" $1
    fi
    exit 1
}

function get_distro(){
# Check for distribution
    print_message "Checking for the distribution ... "
    if [ -f /etc/debian_version ]; then
        OSDIST="Debian"
        print_ok
    elif [ -f /etc/redhat-release ]; then
        OSDIST="RedHat"
        print_ok
    elif [ -f /etc/SuSE-release ]; then
        OSDIST="SUSE"
        print_ok
    else
        OSDIST="unknown"
        print_ok
    fi
}

function check_user(){
# Check for root
    print_message "Checking for user permission ... "
    if [ `${ID} -u` != 0 ] ; then
        print_error "Need root access.\nRun the script as 'root' or with 'sudo' permissions. "
    else
        print_ok
    fi
}

function check_for_puppet(){
# Checking for puppet
    print_message "Checking for previous puppet installations ... "
    if [[ -d '/var/lib/puppet' ]]; then
        print_error "Puppet exist on this system."
    else
        print_ok
    fi
}

function get_confirmation(){
# Get user confirmation
    ${ECHO} -e "Puppet Installer v1 2014-02-12"
    ${ECHO} -e "This script will install PuppetLab puppet v3."
    ${ECHO} -e "Thilina Piyasundara. <mail@thilina.org>"
    ${ECHO} -e ""
    ${ECHO} -e "== [Caution] ==========================================================="
    ${ECHO} -e "This script will replace existing '/etc/hosts' and '/etc/hostname'      "
    ${ECHO} -e "files and will update hostname of the system with following parameter.  "
    ${ECHO} -e ""
    ${ECHO} -e "Report bugs/issues on https://github.com/thilinapiy/puppetinstall/issues"
    ${ECHO} -e ""
    ${ECHO} -en "Installing puppet         : "
                        [ ${MASTER} -eq 1 ] && ${ECHO} -e "Master" || ${ECHO} -e "Agent "
    ${ECHO} -e "Puppet Master FQDN name   : "${MASTERHOSTNAME}
    ${ECHO} -e "Puppet Masters IP address : "${MASTERIP}
    ${ECHO} -e "Domain of the deployment  : "${DOMAIN}
    ${ECHO} -e "FQDN of this node         : "${NODEHOSTNAME}
    ${ECHO} -e "Operating system          : "${OSDIST}
    ${ECHO} -e "System time zone          : "${TIMEZONE}
    ${ECHO} -e ""
    ${ECHO} -e "========================================================================"
    ${ECHO} -e ""
    ${ECHO} -e "Please check your input and confirm by pressing [Enter] to continue.    "
    ${ECHO} -en "Or press [Ctrl] + [c] to stop the installationan exit. : "

    if [ ${FORCEYES} -eq 0 ]; then
        read input
    fi

    if [ ${VERBOSE} -eq 0 ]; then
        ${ECHO} -e "Installation started. Please wait ... "
    fi
}

bashtrap(){
    print_error "\n[Ctrl] + [c] detected ... \nScript will exit now."
}

function update_host(){
# Update '/etc/hosts'
    print_message "Updating '/etc/hosts' ... "
    ${MV} /etc/hosts /etc/hosts-`${DATE} +%Y%m%d-%H%M%S`  && : || print_error "Failed to update '/etc/hosts' file. "
    ${ECHO} "127.0.0.1  localhost" >/etc/hosts && : || print_error "Failed to update '/etc/hosts' file. "
    if [ ! ${MASTER} -eq 1 ]; then
        ${ECHO} "127.0.0.1  ${NODEHOSTNAME}" >>/etc/hosts && : || print_error "Failed to update '/etc/hosts' file. "
    fi
    ${ECHO} "${MASTERIP}  ${MASTERHOSTNAME}" >>/etc/hosts && print_ok || print_error "Failed to update '/etc/hosts' file. "

# Update hostname
    print_message "Updating hostname ... "
    ${HOSTNAME} ${NODEHOSTNAME} && : || print_error "Failed to update hostname. "
}

function install_on_ubuntu(){
# Install puppet master or agent on a Ubuntu/Debian system
#Ubuntu/Debian specific commands.
    BC=`which bc` && : || (echo "Command 'bc' is not installed."; exit 10;)
    GREP=`which grep` && : || (echo "Command 'grep' is not installed."; exit 10;)
    APT=`which apt-get` && : || (echo "Command 'apt-get' is not installed."; exit 10;)
    NTPDEBIAN=`which ntpdate-debian` && : || (echo "Command 'ntpdate-debian' is not installed."; exit 10;)
    DPKG=`which dpkg` && : || (echo "Command 'dpkg' is not installed."; exit 10;)
    DPKGRECONF=`which dpkg-reconfigure` && : || (echo "Command 'dpkg-reconfigure' is not installed."; exit 10;)

# Update the hostname file.
    ${ECHO} ${NODEHOSTNAME} >/etc/hostname && print_ok || print_error "Failed to update '/etc/hostname' file. "

# Do a time sync
    print_message "Updating system time ... "
    ${ECHO} "${TIMEZONE}" > /etc/timezone && : || print_error "Failed to add timezone"
    ${DPKGRECONF} --frontend noninteractive tzdata  && : || print_error "Failed to reconfigure timezone"
    ${NTPDEBIAN} && print_ok || print_error "Failed to synchronize time. "

# Check for version
    if [ -f /etc/os-release  ]; then
        OS_VERSION=`${CAT} /etc/os-release | ${GREP} VERSION_ID | ${CUT} -d "=" -f 2 | ${SED} s/\"//g`
        if [ `${ECHO} "${OS_VERSION}<14.04" | ${BC}` -eq 1 ]; then
        # Install puppet repository
            print_message "Downloading repo file from puppetlabs ... "
            if [ ${VERBOSE} -eq 1 ]; then
                ${WGET} http://apt.puppetlabs.com/puppetlabs-release-precise.deb && print_ok || print_error "Failed to download the repository file from puppetlabs."
            else
                ${WGET} -q http://apt.puppetlabs.com/puppetlabs-release-precise.deb && print_ok || print_error "Failed to download the repository file from puppetlabs."
            fi
            print_message "Installing puppet repository ... "
            ${DPKG} -i puppetlabs-release-precise.deb && print_ok || print_error "Failed to install the repository file of puppetlabs."
        fi
    fi

# Update repository list
    print_message "Updating system repository list ... "
    if [ ${VERBOSE} -eq 1 ]; then
        ${APT} update && print_ok || print_error "Failed to update repository lists."
    else
        ${APT} update -q=2 && : || print_error "Failed to update repository lists."
    fi

    if [ ${MASTER} -eq 1 ]; then
# Install puppet master
        print_message "Installing puppet master ... "
        ${APT} install puppetmaster -y && print_ok || print_error "Failed to install puppet master."
#configure puppet master
        print_message "Configuring puppet master ... "
        ${SED} -i 's/START=no/START=yes/' /etc/default/puppetmaster && : || print_error "Failed to configure puppet master's '/etc/default/puppetmaster'."
        ${ECHO} -e "*.${DOMAIN}" > /etc/puppet/autosign.conf && : || print_error "Failed to configure puppet master's '/etc/puppet/autosign.conf'."
        ${SED} -i "2i server=${MASTERHOSTNAME}" /etc/puppet/puppet.conf && print_ok || print_error "Failed to configure puppet master's '/etc/puppet/puppet.conf'."
        print_message "Restarting puppet master service ... "
        /etc/init.d/puppetmaster restart && ${ECHO} -e "Installation completed successfully." || print_error "Failed to restart puppet master."
    else
# Install puppet agent
        print_message "Installing puppet agent ... "
        ${APT} install puppet -q=2 -y && print_ok || print_error "Failed to install puppet agent."
        print_message "Configuring puppet agent ... "
        ${SED} -i 's/START=no/START=yes/' /etc/default/puppet && : || print_error "Failed to configure puppet agent's '/etc/default/puppet'."
        ${SED} -i "2i server=${MASTERHOSTNAME}" /etc/puppet/puppet.conf && print_ok || print_error "Failed to configure puppet agent's '/etc/puppet/puppet.conf'."
        print_message "Restarting puppet agent service ... "
        /etc/init.d/puppet restart && ${ECHO} -e "Installation completed successfully." || print_error "Failed to restart puppet agent."
    fi
}

function install_on_redhat(){
# Install puppet master and agent on redhat base systems
    YUM=`which yum` && : || (echo "Command 'yum' is not installed."; exit 10;)
    RPM=`which rpm` && : || (echo "Command 'rpm' is not installed."; exit 10;)
    EL_VERSION=$( ${UNAME} -r | ${AWK} -F "el" '{print $2}' | ${AWK} -F "." '{print $1}')
    REPO_URL="http://yum.puppetlabs.com/puppetlabs-release-el-${EL_VERSION}.noarch.rpm"

# Update the hostname in network file.
    ${SED} -i s/^HOSTNAME=.*/HOSTNAME=${NODEHOSTNAME}/g /etc/sysconfig/network && print_ok || print_error "Failed to update '/etc/sysconfig/network' file. "

# Do a time sync
    print_message "Updating system time ... "
    which ntpdate && : || (echo "Installing ntpdate ..."; ${YUM} install -y -q ntpdate)
    NTPDATE="ntpdate"
    ${CP} /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && : || print_error "Failed to reconfigure timezone"
    ${NTPDATE} pool.ntp.org && print_ok || print_error "Failed to synchronize time. "

# Install puppet repository
    print_message "Downloading repo file from puppetlabs ... "
    if [ ${VERBOSE} -eq 1 ]; then
        ${WGET} ${REPO_URL} && print_ok || print_error "Failed to download the repository file from puppetlabs."
    else
        ${WGET} -q ${REPO_URL} && print_ok || print_error "Failed to download the repository file from puppetlabs."
    fi
    print_message "Installing puppet repository ... "
    ${RPM} -i puppetlabs-release-*.rpm && print_ok || print_error "Failed to install puppetlabs repository."

    if [ ${MASTER} -eq 1 ]; then
# Install puppet master
        print_message "Installing puppet server ... "
        ${YUM} install puppet-server -q -y && print_ok || print_error "Failed to install puppet server."
#configure puppet master
        print_message "Configuring puppet server ... "
        ${ECHO} -e "*.${DOMAIN}" > /etc/puppet/autosign.conf && : || print_error "Failed to configure puppet server's '/etc/puppet/autosign.conf'."
        ${SED} -i "2i server=${MASTERHOSTNAME}" /etc/puppet/puppet.conf && print_ok || print_error "Failed to configure puppet server's '/etc/puppet/puppet.conf'."
        print_message "Restarting puppet server service ... "
        /etc/init.d/puppetmaster restart && ${ECHO} -e "Installation completed successfully. \nOpen port 8140 via IPtables." || print_error "Failed to restart puppet server."
    else
# Install puppet agent
        print_message "Installing puppet agent ... "
        ${YUM} install puppet -y && print_ok || print_error "Failed to install puppet agent."
        print_message "Configuring puppet agent ... "
        ${SED} -i "2i server=${MASTERHOSTNAME}" /etc/puppet/puppet.conf && print_ok || print_error "Failed to configure puppet agent's '/etc/puppet/puppet.conf'."
        print_message "Restarting puppet agent service ... "
        /etc/init.d/puppet restart && ${ECHO} -e "Installation completed successfully." || print_error "Failed to restart puppet agent."
    fi
}

function install_on_sles(){
# Install puppet master and agent on SLES base systems
    ZYPPER=`which zypper` && : || (echo "Command 'zypper' is not installed."; exit 10;)
    RPM=`which rpm` && : || (echo "Command 'rpm' is not installed."; exit 10;)

# Do a time sync
    print_message "Updating system time ... "
    which ntp && : || (echo "Installing NTP daemon ..."; ${ZYPPER} install -y ntp)
    NTPDATE="ntpdate"
    ${CP} /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && : || print_error "Failed to reconfigure timezone"
    ${NTPDATE} pool.ntp.org && print_ok || print_error "Failed to synchronize time. "

# Update the hostname file.
    ${ECHO} ${NODEHOSTNAME} >/etc/HOSTNAME && print_ok || print_error "Failed to update '/etc/HOSTNAME' file. "

    if [ ${MASTER} -eq 1 ]; then
# Install puppet master
        print_message "Installing puppet server ... "
        ${ZYPPER} install -y puppet-server && print_ok || print_error "Failed to install puppet server."
#configure puppet master
        print_message "Configuring puppet server ... "
        ${ECHO} -e "*.${DOMAIN}" > /etc/puppet/autosign.conf && : || print_error "Failed to configure puppet server's '/etc/puppet/autosign.conf'."
        ${SED} -i "2i server=${MASTERHOSTNAME}" /etc/puppet/puppet.conf && print_ok || print_error "Failed to configure puppet server's '/etc/puppet/puppet.conf'."
        print_message "Restarting puppet server service ... "
        /etc/init.d/puppetmasterd restart && ${ECHO} -e "Installation completed successfully. \nOpen port 8140 via IPtables." || print_error "Failed to restart puppet server."
    else
# Install puppet agent
        print_message "Installing puppet agent ... "
        ${ZYPPER} install -y puppet && print_ok || print_error "Failed to install puppet agent."
        print_message "Configuring puppet agent ... "
        ${SED} -i "2i server=${MASTERHOSTNAME}" /etc/puppet/puppet.conf && print_ok || print_error "Failed to configure puppet agent's '/etc/puppet/puppet.conf'."
        print_message "Restarting puppet agent service ... "
        /etc/init.d/puppet restart && ${ECHO} -e "Installation completed successfully." || print_error "Failed to restart puppet agent."
    fi
}


# Check all input parameters.
while getopts ":vhmd:n:s:t:y --help" opt; do
    case ${opt} in
        h|--help)
            print_usage
            exit 0
            ;;
        v)
            VERBOSE=1
            ;;
        d)
            DOMAIN=${OPTARG}
            ;;
        n)
            NODENAME=${OPTARG}
            ;;
        m)
            MASTER=1
            ;;
        s)
            MASTERIP=${OPTARG}
            ;;
        t)
            TIMEZONE=${OPTARG}
            ;;
        y)
            FORCEYES=1
            ;;
        :)
            ${ECHO} -e "puppetinstall: Option -${OPTARG} requires an argument."
            ${ECHO} -e "puppetinstall: '--help or -h' gives usage information."
            exit 1
            ;;
         \?)
            ${ECHO} -e "puppetinstall: Invalid option: -${OPTARG}"
            ${ECHO} -e "puppetinstall: '--help or -h' gives usage information."
            exit 1
            ;;
    esac
done

# Validate the user
check_user

if [ -z ${TIMEZONE} ]; then
    TIMEZONE="Etc/UTC"
fi

if [ ${MASTER} -eq 1 ]; then
    NODENAME="puppet"
    [ -z ${MASTERIP} ] && MASTERIP="127.0.0.1" || :
fi

if [ -z ${DOMAIN} ] || [ -z ${MASTERIP} ] || [ -z ${NODENAME} ]; then
    ${ECHO} -e "puppetinstall: Require a domain, host/node name and puppet master ip address."
    ${ECHO} -e "puppetinstall: '--help or -h' gives usage information."
    exit 1
fi

# Set the hostname
MASTERHOSTNAME="puppet.${DOMAIN}"
NODEHOSTNAME="${NODENAME}.${DOMAIN}"

# Check puppet exist on the system
check_for_puppet
# Get the operating system distribution
get_distro
get_confirmation

case ${OSDIST} in
    Debian)
        update_host
        install_on_ubuntu
        ;;
    RedHat)
        update_host
        install_on_redhat
        ;;
    SUSE)
        update_host
        install_on_sles
        ;;
    Fedora)
        print_error "Fedora is not recommended. Try to use CentOS."
        ;;
    *)
        print_error "System was not identified."
        ;;
esac

exit 0
