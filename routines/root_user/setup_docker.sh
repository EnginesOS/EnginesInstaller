
function install_docker_components {
  echo "Installing Docker"		
		 apt-get install -y apt-transport-https  libreadline-dev  linux-image-extra-$(uname -r) lvm2 thin-provisioning-tools openssh-server g++ >>/tmp/engines_install.log
		 echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
		 apt-get -y update >>/tmp/engines_install.log
 
	
		 wget -qO- https://get.docker.io/gpg | apt-key add - >>/tmp/engines_install.log
		 apt-get -y  --force-yes install lxc-docker >>/tmp/engines_install.log
		 update-rc.d docker defaults 
		 service docker start
  }

function configure_docker {
  echo "Configuring Docker DNS settings"	 
		# echo "DOCKER_OPTS=\"--storage-driver=devicemapper --dns  172.17.42.1 --dns 8.8.8.8  --bip=172.17.42.1/16\"" >> /etc/default/docker
		 echo "DOCKER_OPTS=\" --storage-driver=aufs --dns  172.17.42.1 --dns 8.8.8.8  --bip=172.17.42.1/16\"" >> /etc/default/docker
	
	#for systemd
		if test -f /lib/systemd/system/docker.service
			then
				cp ${top}/install_source/lib/systemd/system/docker.service /lib/systemd/system/docker.service
			fi
		 update-rc.d docker defaults 
		 service docker start	
		  if test -f /bin/systemctl
		  then
		 	systemctl enable docker
		 fi
		 
		 #need to restart to get dns set
		 service docker stop
		 sh -c echo 1 \> /sys/fs/cgroup/memory/memory.use_hierarchy
		 sleep 20
		 service docker start
		  
  }
 