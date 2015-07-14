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

ln -s /opt/engines/bin/set_ip.sh /etc/network/if-up.d/

chown -R engines /opt/engines/
 

#setup_ssl
copy_install_ssl_cert

make_dirs

set_permissions



chmod +x  ${top}/complete_install.sh

echo -n ${top} >/tmp/.install_dir
su -l engines -c  ${top}/complete_install.sh 


 