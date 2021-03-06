#!/bin/bash
#engines section of install run as engines


RUBY_VER=2.5.1

export RUBY_VER
top=`cat /tmp/.install_dir`
. ${top}/routines/engines_user/services_first_start.sh
. ${top}/routines/engines_user/crontab.sh
. ${top}/routines/engines_user/script_keys.sh


echo Installing Mgmt Keys
setup_mgmt_keys

echo Installation complete
touch ~/.complete_install
/opt/engines/system/scripts/startup/set_ip.sh

CONTROL_HTTP=yes
export CONTROL_HTTP

CONTROL_IP=`/opt/engines/bin/system_ip.sh`
export CONTROL_IP
	
DOCKER_IP=`/opt/engines/bin/docker_ip.sh`
export DOCKER_IP

echo Downloading and starting services
create_services  

rm -f /opt/engines/run/system/flags/reboot_required 
rm -f /opt/engines/run/system/flags/engines_rebooting 
rm -f /opt/engines/run/system/flags/building_params 
cp /etc/os-release /opt/engines/etc/os-release-host
sleep 60
CONTROL_HTTP=y /opt/engines/bin/engines service firstrun wait_for_startup 120

CONTROL_HTTP=y /opt/engines/bin/engines service firstrun wait_for_startup 120
# FixME Test other services as well
if ! test running = `CONTROL_HTTP=y /opt/engines/bin/engines service firstrun state`
 then
   echo "INSTALLATION FAILED"
   echo "First Run is not running"
   exit
  fi




gw_ifac=`netstat -nr |grep ^0.0.0.0 | awk '{print $8}' | head -1`

lan_ip=`/sbin/ifconfig $gw_ifac |grep "inet "  |  awk '{print $2}'`

ext_ip=`curl -s http://ipecho.net/ |grep "Your IP is" | sed "/^.* is /s///" | sed "/<.*$/s///"`

if ! test -n $ext_ip
 then
   ext_ip=`curl -s http://ipecho.net/ |grep "Your IP is" | sed "/^.* is /s///" | sed "/<.*$/s///"`
fi
  
echo please visit https://${lan_ip}:8484/ or https://${ext_ip}:8484/ to complete installation
echo 'Waiting for First run Form Submission' 

while ! test -f /opt/engines/run/system/flags/first_run_ready
 do
    sleep 5
done

 
/opt/engines/system/install/_first_start.sh 