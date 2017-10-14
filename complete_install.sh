#!/bin/bash
#engines section of install run as engines


RUBY_VER=2.3.1

export RUBY_VER
top=`cat /tmp/.install_dir`
. ${top}/routines/engines_user/services_first_start.sh
. ${top}/routines/engines_user/crontab.sh
. ${top}/routines/engines_user/script_keys.sh

#echo Installing Ruby 
#echo Please wait this step will take 5 to 10 minutes

#echo Installing Ruby Gems

 
echo Installing Mgmt Keys
setup_mgmt_keys

echo Installation complete
touch ~/.complete_install
/opt/engines/system/scripts/startup/set_ip.sh
 
DOCKER_IP=`/opt/engines/bin/docker_ip.sh`
export DOCKER_IP


echo Downloading and starting services
create_services  

rm -f /opt/engines/run/system/flags/reboot_required 
rm -f /opt/engines/run/system/flags/engines_rebooting 
rm -f /opt/engines/run/system/flags/building_params 
cp /etc/os-release /opt/engines/etc/os-release-host

/opt/engines/bin/engines service firstrun wait_for_startup 125

# FixME Test other services as well
if test running = `/opt/engines/bin/engines service firstrun state`
 then
   echo "INSTALLATION FAILED"
   echo First Run is not running"
   exit
  fi


echo 'Waiting for First run Form Submission' 
while ! test -f /tmp/first_start.log
 do
    sleep 5
done

gw_ifac=`netstat -nr |grep ^0.0.0.0 | awk '{print $8}' | head -1`

lan_ip=`/sbin/ifconfig $gw_ifac |grep "inet addr"  |  cut -f 2 -d: |cut -f 1 -d" "`

ext_ip=`curl -s http://ipecho.net/ |grep "Your IP is" | sed "/^.* is /s///" | sed "/<.*$/s///"`

if ! test -n $ext_ip
 then
   ext_ip=`curl -s http://ipecho.net/ |grep "Your IP is" | sed "/^.* is /s///" | sed "/<.*$/s///"`
fi
  
echo please visit http://${lan_ip}:8484/ or http://${ext_ip}:8484/ to complete installation

tail -f /tmp/first_start.log
 
