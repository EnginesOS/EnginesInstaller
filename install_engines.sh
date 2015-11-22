#!/bin/bash
#root section of install run as root
RUBY_VER=2.2.2

default_branch=`cat default_branch`

touch /tmp/engines_install.log

if test $# -gt 0
	then
		branch=$1
	else
		branch=$default_branch
		echo "defaulting to $branch"
	fi
	
export branch

export RUBY_VER
top=`pwd`
export top

. ${top}/routines.sh
 . ${top}/routines/installer/create_service_dirs.sh
  . ${top}/routines/installer/system_checks.sh
  . ${top}/routines/installer/setup_engines_user.sh
  . ${top}/routines/installer/os_routines.sh
   . ${top}/routines/installer/setup_engines_user.sh
 . ${top}/routines/installer/install_engines_system.sh
. ${top}/routines/installer/script_keys.sh
 . ${top}/routines/installer/configure_net.sh 
  . ${top}/routines/installer/init_ssl_cert.sh 
  
can_install

dpkg-reconfigure tzdata


configure_git 

  create_engines_user
  update_os
  setup_startup_script
  install_docker_components
  configure_docker
  configure_engines_user
  install_rbenv    	  		 
  setup_dns 	
  setup_ip_script
 set_permissions

make_dirs

chmod +x  ${top}/complete_install.sh

echo -n ${top} >/tmp/.install_dir

su -l engines -c  ${top}/complete_install.sh 

