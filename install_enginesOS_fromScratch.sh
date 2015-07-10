#!/bin/bash

RUBY_VER=2.2.2

export RUBY_VER

. ./routines.sh
 if test -f /opt/engines/installers/routines.sh
 then
		. /opt/engines/installers/routines.sh
 fi


dpkg-reconfigure tzdata


configure_git 

install_docker_and_components
ln -s /opt/engines/bin/set_ip.sh /etc/network/if-up.d/
chown -R engines /opt/engines/
passwd engines  

generate_ssl


make_dirs

set_permissions

cp -r /opt/engines/system/install_source/* /
#cat /opt/engines/system/install_source/etc/sudoers >> /etc/sudoers

chmod +x ./complete_install.sh

su -l engines -c ./complete_install.sh


 