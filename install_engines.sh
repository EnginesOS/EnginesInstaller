#!/bin/bash
#root section of install run as root
RUBY_VER=2.2.2



export RUBY_VER
top=`pwd`
export top

if ! test -d ./routines/
 then
 	echo "Error: Script must be run from within the EnginesInstaller dir $top "
 	exit 127
 fi 
 
. ${top}/routines.sh
 . ${top}/routines/root_user/create_service_dirs.sh
  . ${top}/routines/root_user/system_checks.sh
  . ${top}/routines/root_user/setup_engines_user.sh
  . ${top}/routines/root_user/os_routines.sh
   . ${top}/routines/root_user/setup_engines_user.sh
 . ${top}/routines/root_user/install_engines_system.sh

 . ${top}/routines/root_user/configure_net.sh 
  . ${top}/routines/root_user/init_ssl_cert.sh 
    . ${top}/routines/root_user/setup_docker.sh 
 
can_install


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
  make_dirs
  set_permissions

chmod +x  ${top}/complete_install.sh

echo -n ${top} >/tmp/.install_dir

su -l engines -c  ${top}/complete_install.sh 

