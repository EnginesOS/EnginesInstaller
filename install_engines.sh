#!/bin/bash
#root section of install run as root
RUBY_VER=2.2.2

touch /tmp/engines_install.log


if test $# -gt 0
	then
		branch=$1
	else
		branch=alpha
	fi
	
export branch

export RUBY_VER
top=`pwd`
export top

. ${top}/routines.sh
 
 

dpkg-reconfigure tzdata


configure_git 

install_docker_and_components



#chown -R engines /opt/engines/
 


make_dirs




#set_permissions



chmod +x  ${top}/complete_install.sh

echo -n ${top} >/tmp/.install_dir
su -l engines -c  ${top}/complete_install.sh 


 