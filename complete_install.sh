#!/bin/bash
#engines section of install run as engines
RUBY_VER=2.2.2
export RUBY_VER
top=`cat /tmp/.install_dir`
.  ${top}/routines/engines_user/services_first_start.sh
.  ${top}/routines/engines_user/crontab.sh
. ${top}/routines/engines_user/script_keys.sh

echo Installing Ruby 
rbenv install 2.2.2 >/dev/null 
rbenv global 2.2.2 
rbenv  local 2.2.2
echo Installing Ruby Gems
 	~/.rbenv/shims/gem install multi_json rspec rubytree git  rest-client >/dev/null
echo Installing Mgmt Keys
setup_mgmt_keys

echo Installation complete
touch ~/.complete_install
 /opt/engines/bin/set_ip.sh
echo Downloading and starting services
create_services  


grep follow_start.sh ~engines/.bashrc
	if test $? -ne 0
		then
			echo  /opt/engines/bin/follow_start.sh >> ~engines/.bashrc
	fi

setup_engines_crontab
# pretend if install changed grub options
touch /opt/engines/run/system/flags/engines_rebooting
/opt/engines/bin/follow_start.sh 