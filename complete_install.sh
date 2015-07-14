#!/bin/bash
#engines section of install run as engines
RUBY_VER=2.2.2
export RUBY_VER
top=`cat /tmp/.install_dir`
.  ${top}/routines.sh

rbenv install 2.2.2
rbenv global 2.2.2
rbenv  local 2.2.2
 	~/.rbenv/shims/gem install multi_json rspec rubytree git 


touch /opt/engines/.complete_install
create_services 
#sudo reboot
cp ${top}/install_source/home/engines/follow_start.sh ~
grep follow_start.sh ~/.bashrc
	if test $? -ne 0
		then
			echo  ~/follow_start.sh >> ~/.bashrc
	fi


