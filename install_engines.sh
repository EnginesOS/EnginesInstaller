#!/bin/bash
#root section of install run as root
RUBY_VER=2.2.2

default_branch=`cat default_branch`

if ! test `id |cut -f2 -d=|cut -f1 -d\(` -eq 0
	then
		echo "This script must be run as root or as sudo $0"
		exit 127
	fi
	
 if dpkg-query -W -f'${Status}' "lxc-docker" 2>/dev/null | grep -q "ok installed"; then
 	echo "Cannot install onto an existing docker host"
 	exit 127
 fi

 ps -ax |grep dnsmas | grep -v grep 
 if test $? -eq 0
  then
  echo "Cannot Install on machine with dnsmasq enable, Please change your system "
  exit 127
 fi
 ps -ax |grep named | grep -v grep 
 if test $? -eq 0
  then
  echo "Cannot Install on machine with bind/named enable, Please change your system "
  exit 127
 fi

used_ports=` netstat -na | cut -f4 -d" "`

for port in `cat basic_ports_required`
 do 	
 	   for used_port in $used_ports
 	    do
 	     	if test $used_port = $port 
 	 			then
 	 			echo error port $port taken
 	 			exit 127
 	 		fi 	
 	    done

  done

if ! test -f ./routines.sh
 then
 	echo "Error: Script must be run from within the EnginesInstaller dir "
 	exit 127
 fi 




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
 


dpkg-reconfigure tzdata


configure_git 

install_docker_and_components



#chown -R engines /opt/engines/
 


make_dirs




#set_permissions



chmod +x  ${top}/complete_install.sh

echo -n ${top} >/tmp/.install_dir
su -l engines -c  ${top}/complete_install.sh 


 