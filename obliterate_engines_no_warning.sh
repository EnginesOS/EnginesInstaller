#!/bin/bash



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
if test $# -eq 1
 then
   if test $1 = "-k"
     then 
       keep=1
     fi
 fi
 
if test -d EnginesInstaller
	then
	docker stop `docker ps |awk '{print $1}' `
	 docker rm `docker ps -a |awk '{print $1}' `
	 if test $keep -eq 0
	 	then
	 		docker rmi `docker images |awk '{print $3}' `
	 	fi
		service docker stop
		rm -r /var/lib/engines
		rm -r /var/log/engines
		rm -r /opt/engines
		 rm -r /var/spool/cron/crontabs/engines
		apt-get -y remove lxc-docker
		apt-get -y autoremove
		userdel -r  engines

		cat /etc/rc.local |grep -v engines >/tmp/.local
		cp /tmp/.local   /etc/rc.local
		 rm -r EnginesInstaller
		groupdel containers
				groupdel engines
		rm -rf /usr/local/rbenv
		 rm /etc/network/if-up.d/set_ip.sh 
		rm -r /home/engines/.ssh
		
		rm -fr /home/engines/.rbenv
    else
      echo Script must be run as root from the dir that contains EnginesInstaller
fi