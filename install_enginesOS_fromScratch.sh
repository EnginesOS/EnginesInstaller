#!/bin/bash
#root section of install run as root
RUBY_VER=2.2.2

export RUBY_VER
top=`pwd`
export top

. ${top}/routines.sh
 
 

dpkg-reconfigure tzdata


configure_git 

install_docker_and_components

if ! test -f  /etc/network/if-up.d/set_ip.sh
 then 
	ln -s /opt/engines/bin/set_ip.sh /etc/network/if-up.d/
fi

#chown -R engines /opt/engines/
 


make_dirs




#set_permissions



chmod +x  ${top}/complete_install.sh

echo -n ${top} >/tmp/.install_dir
su -l engines -c  ${top}/complete_install.sh 


 