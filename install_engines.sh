#!/bin/bash
#root section of install run as root
RUBY_VER=2.3.1

export RUBY_VER
top=`pwd`
export top

if ! test -d ./routines/
 then
 	echo "Error: Script must be run from within the EnginesInstaller "
 	exit 127
 fi 
 
. ${top}/routines.sh
. ${top}/routines/root_user/create_service_dirs.sh
. ${top}/routines/root_user/system_checks.sh
. ${top}/routines/root_user/setup_engines_user.sh
. ${top}/routines/root_user/os_routines.sh
. ${top}/routines/root_user/setup_engines_user.sh
. ${top}/routines/root_user/install_engines_system.sh
. ${top}/routines/root_user/virtual_hw_install.sh
. ${top}/routines/root_user/physical_hw_install.sh
. ${top}/routines/root_user/configure_net.sh 
. ${top}/routines/root_user/init_ssl_cert.sh 
. ${top}/routines/root_user/setup_docker.sh 
. ${top}/routines/root_user/service_definitions.sh 

systemctl disable systemd-resolved 
service systemd-resolved stop

 
can_install

default_branch=`cat default_branch`

touch /tmp/engines_install.log

if test $# -gt 0
 then	
	flavor=`echo $1 | awk -F/ '{print $1}' `
	branch=`echo $1 | awk -F/ '{print $2}'`
	 if test -z $branch
	  then
	   branch=$flavor
	   flavor=engines
	  fi
else
	branch=$default_branch
	flavor=engines
	echo "defaulting to $branch"
fi
	export flavor
export branch

#dpkg-reconfigure tzdata

configure_git 
echo -n $flavor > /opt/engines/flavor
create_engines_user
update_os

install_docker_components
  
cat /proc/cpuinfo  |grep flags |grep hyper >/dev/null
if test $? -eq 0
 then
   virtual_hw_install
else
   physical_hw_install
fi
    
configure_docker
setup_engines_service
configure_engines_user
# install_rbenv
install_ruby
setup_dns 	
setup_ip_script
setup_service_definitions
make_dirs
set_permissions

chmod +x  ${top}/complete_install.sh

echo -n ${top} >/tmp/.install_dir

#service engines enable
#service engines start
update_os  >& /dev/null 
apt-get upgrade -y linux-headers-generic linux-headers-virtual linux-image-virtual  linux-virtual  linux-image-extra-$(uname -r) >& /dev/null 
 
su -l engines -c  ${top}/complete_install.sh 
 