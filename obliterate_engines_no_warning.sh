#!/bin/bash

if test -f /opt/engines/etc/no_obliterate
 then
  echo "Installation Protected From Obliteration"
  echo " You will need to remove the file /opt/engines/etc/no_obliterate to run $0"
  exit
 fi
 
if ! test `id |cut -f2 -d=|cut -f1 -d\(` -eq 0
	then
		echo "This script must be run as root or as sudo $0"
		exit 
	fi
	
	

w |grep engines >/dev/null
if test $? -eq 0
then
	echo cannot uninstalled while engines user is logged
	exit
fi


read -p "Are you sure? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

echo "15 seconds until destruction with no visual countdown starting now"
echo "Docker and ALL docker Images will be Deleted -k to keep docker images"
echo "Ctl-C now if this is not want you want"
sleep 20
keep=0
keep_rbenv=0

if test $# -eq 1
 then
   if test $1 = "-k"
     then 
       keep=1
   elif test $1 = "-r"
   then 
   	keep_rbenv=1
   	echo "Keeping Rbenv"
     fi
 fi
 
if test -d EnginesInstaller
	then
	# Update first
	cd EnginesInstaller
	git pull
	cd ..
	
	#then obliterate
	crontab -u engines -r
	rm -rf /var/spool/cron/crontabs/engines
	service cron restart
	
	docker info >/dev/null
	 if test $? -eq 0
		service docker restart
			sleep 5
			containers=`docker ps -a |grep -i paused |awk '{print $1}' `
			if ! test -z $containers
			 then
				docker stop $containers
			fi
			containers=`docker ps -q |awk '{print $1}'` 
		if ! test -z $containers
			 then
				docker rm $containers
			fi
	 
	 	if test $keep -eq 0
	 		then
	 		images=`docker images -q |awk '{print $1}'
		if ! test -z $images
			 then

	 			docker rmi `docker images -q |awk '{print $1}' `
	 		 fi
	 		fi
			service docker stop
			rm -rf /var/lib/engines
			rm -rf /var/log/engines
			rm -rf /opt/engines
		
			apt-get -y remove lxc-docker
			apt-get -y autoremove
			rm /etc/default/docker 
			if test $keep -eq 0
	 		then	 			
	 			rm -rf /var/lib/docker
	 		fi
			
		fi
		engines_id=21000
		pids=`ps -axl |grep -v grep | awk '{print "_" $2 "_ "  $3}'  |grep _21000_ | awk '{ print $2}'`
		
		if ! test -z "$pids"
		 then
		 	kill -TERM $pids
		 fi
		pids=`ps -axl |grep -v grep | awk '{print "_" $2 "_ "  $3}'  |grep _21000_ | awk '{ print $2}'`
		
		if ! test -z "$pids"
		 then
		 	kill -KILL $pids
		 fi
		 sleep 6
		 pids=`ps -axl |grep -v grep | awk '{print "_" $2 "_ "  $3}'  |grep _21000_ | awk '{ print $2}'`
		
		if ! test -z "$pids"
		 then
		 	echo engines user still has processes running pid(s) $pids
		 	exit
		 fi
		 
		gw_ifac=`netstat -nr |grep ^0.0.0.0 | awk '{print $8}' |head -1`
		ip=`/sbin/ifconfig $gw_ifac |grep "inet addr"  |  cut -f 2 -d: |cut -f 1 -d" "`
		
		userdel -r  engines
		service cron restart		
		cat /etc/resolvconf/resolv.conf.d/head  | grep -v "nameserver $ip"  >/tmp/.local
		mv  /tmp/.local /etc/resolvconf/resolv.conf.d/head
		cat /etc/resolv.conf  | grep -v "$ip"  >/tmp/.local
		mv  /tmp/.local  /etc/resolv.conf 

 #cat /etc/dhcp/dhclient.conf| grep -v 172.17.42.1>/tmp/.local
 #mv /tmp/.local /etc/dhcp/dhclient.conf
		cat /etc/rc.local |grep -v engines >/tmp/.local
		cp /tmp/.local   /etc/rc.local
		 rm -r EnginesInstaller
		groupdel containers
		#usermod backup -r -G engines
		usermod  -G backup backup
		
		groupdel engines
		if test $keep_rbenv -eq 0
		 then
		 	echo "Removing rbenv"
			rm -rf /usr/local/rbenv
			cat ~/.bashrc | grep -v rbenv >/tmp/.b
			mv /tmp/.b  ~/.bashrc 
		fi
		
		rm /etc/network/if-up.d/set_ip.sh 
		rm -r /home/engines/.ssh
		
		rm -fr /home/engines/.rbenv
		
		cat /etc/default/grub | grep -v "cgroup_enable=memory swapaccount=1 cgroup_enable=memory use_hierarchy" > /tmp/grub
		cp /tmp/grub /etc/default/grub
		update-grub
    else
      echo Script must be run as root from the dir that contains EnginesInstaller
fi
