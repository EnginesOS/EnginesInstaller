
function install_docker_components {
  echo "Installing Docker"		
		 apt-get install -y apt-transport-https  libreadline-dev  linux-image-extra-$(uname -r) lvm2 thin-provisioning-tools openssh-server g++ >>/tmp/engines_install.log
		 echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
		 apt-get -y update >>/tmp/engines_install.log
 		apt-get -y install haveged
	
		 wget -qO- https://get.docker.io/gpg | apt-key add - >>/tmp/engines_install.log
		 apt-get -y  --force-yes install lxc-docker >>/tmp/engines_install.log
		 update-rc.d docker defaults 
		 service docker start
  }

function configure_docker {
  echo "Configuring Docker DNS settings"	 

#echo GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1 cgroup_enable=memory use_hierarchy" >> /etc/default/grub
echo GRUB_CMDLINE_LINUX=\"cgroup_enable=memory swapaccount=1 cgroup_enable=memory use_hierarchy\" >> /etc/default/grub
update-grub
		# echo 1 > /sys/fs/cgroup/memory/memory.use_hierarchy
		 echo "DOCKER_OPTS=\" --storage-driver=aufs  --dns 8.8.8.8  \"" > /etc/default/docker
	
	#for systemd
	
		if test -f /lib/systemd/system/docker.service
			then
			if -f /bin/systemctl
			 then
				systemctl unmask docker.service
				systemctl unmask docker.socket
				systemctl start docker.service
			 fi
				cp ${top}/install_source/lib/systemd/system/docker.service.blank  /lib/systemd/system/docker.service
				 service docker start	
				  service docker stop
				  ip=`ifconfig docker0  |grep "inet addr:" |cut -f2 -d: |awk '{print $1}'`
				  cat ${top}/install_source/lib/systemd/system/docker.service | sed "/IP/s//$ip/" > /lib/systemd/system/docker.service
				   systemctl  daemon-reload
				  
				   service docker start	
			fi
		 update-rc.d docker defaults 
		 service docker start	
		ip=`ifconfig docker0  |grep "inet addr:" |cut -f2 -d: |awk '{print $1}'`
		 
		  if test -f /bin/systemctl
		  then
		 	systemctl enable docker
		 fi
		 
		 #ensure docker0 is configured
		  docker run --name test busybox
		 		  
		   ip=`ifconfig docker0  |grep "inet addr:" |cut -f2 -d: |awk '{print $1}'`
		   
		   docker stop test
		  docker rm test
		 #need to restart to get dns set
		 service docker stop
	
	docker_db_state=`strings /var/lib/docker/network/files/local-kv.db`	 
		 	if test -z "$docker_db_state"
		then
			rm /var/lib/docker/network/files/local-kv.db
	fi
		 
		 if test -z "$ip"
		  then 
		  	ip='172.17.0.1'
		  fi
		
		 echo "DOCKER_OPTS=\" --storage-driver=aufs --dns $ip --dns 8.8.8.8  \"" > /etc/default/docker
		
		 sleep 20
		 service docker start
		  
  }
 