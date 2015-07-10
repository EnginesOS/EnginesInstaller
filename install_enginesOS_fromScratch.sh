#!/bin/bash

RUBY_VER=2.2.2

export RUBY_VER

. ./routines.sh



dpkg-reconfigure tzdata

install_docker_and_components

make_dirs

set_permissions



passwd engines  

chmod +x ./complete_install.sh

su -l engines -c ./complete_install.sh


 