#!/bin/bash
#engines section of install run as engines

docker_ip=`ifconfig docker0 |grep "inet add" |cut -f2 -d: | cut -f1 -d" "`
rm -f /opt/engines/etc/net/management
echo -n $docker_ip > /opt/engines/etc/net/management

RUBY_VER=2.2.2

export RUBY_VER
top=`cat /tmp/.install_dir`
.  ${top}/routines/engines_user/services_first_start.sh
.  ${top}/routines/engines_user/crontab.sh
. ${top}/routines/engines_user/script_keys.sh

echo Installing Ruby 
echo Please wait this step will take 5 to 10 minutes
rbenv install 2.2.2 >/dev/null 
rbenv global 2.2.2 
rbenv  local 2.2.2
echo Installing Ruby Gems
 	~/.rbenv/shims/gem install bundler multi_json rspec rubytree git net_http_unix yajl-ruby rest-client >/dev/null
echo Installing Mgmt Keys
setup_mgmt_keys

echo Installation complete
touch ~/.complete_install
 /opt/engines/system/scripts/startup/set_ip.sh
echo Downloading and starting services
create_services  

rm -f /opt/engines/run/system/flags/reboot_required 
rm -f /opt/engines/run/system/flags/engines_rebooting 
rm -f /opt/engines/run/system/flags/building_params 
cp /etc/os-release /opt/engines/etc/os-release-host

grep follow_start.sh ~engines/.bashrc
	if test $? -ne 0
		then
			
	fi

setup_engines_crontab
# pretend if install changed grub options
#dont reboot as well the cert error post first run
#touch /opt/engines/run/system/flags/reboot_required




