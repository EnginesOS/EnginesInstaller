#!/bin/bash
#root section of install run as root
RUBY_VER=2.2.2

if ! test `id |cut -2 -d=|cut -f1 -d\(` -eq 0
	then
		echo "This script must be run as root or as sudo $0"
		exit 
	fi
	
 if dpkg-query -W -f'${Status}' "lxc-docker" 2>/dev/null | grep -q "ok installed"; then
 	echo "Cannot install onto an existing docker host"
 	exit
 fi

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


 