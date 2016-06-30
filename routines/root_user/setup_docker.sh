
#packages="apt-transport-https  libreadline-dev  linux-image-extra-$(uname -r) lvm2 thin-provisioning-tools openssh-server haveged"
. ${top}/packages

function install_docker_components {

for package in $packages
 do
 	 dpkg -l $package
 	 if test $? -ne 0
 	 then
 	 	packages_to_install="$packages_to_install $package"
 	 fi
 done

echo $packages_to_install >/opt/engines/system/packages_installed
  echo "Installing Docker"		
    if ! test -z $packages_to_install
      then
		 apt-get install -y  $packages_to_install >>/tmp/engines_install.log
      fi
       grep UBUNTU_CODENAME=xenial /etc/os-release >/dev/null
       if test $? -eq 0
       then
       	echo "setting up for xenial"
		 echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
		 apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
		  apt-get -y  --force-yes install docker.io >>/tmp/engines_install.log
        else
		 echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
		  wget -qO- https://get.docker.io/gpg | apt-key add - >>/tmp/engines_install.log
		 apt-get -y  --force-yes install lxc-docker >>/tmp/engines_install.log
		fi
		 
		 apt-get -y update >>/tmp/engines_install.log
		 apt-get -y upgrade
		 #if virutal
 	 apt-get upgrade -y linux-headers-generic linux-headers-virtual linux-image-virtual  linux-virtual  linux-image-extra-$(uname -r) 
 		#else
 		# apt-get upgrade -y linux-headers-generic linux linux-image-extra-$(uname -r) 
 		
	
		
		 update-rc.d docker defaults 
		 service docker start
  }

function configure_docker {
  echo "Configuring Docker DNS settings"	 

#echo GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1 cgroup_enable=memory use_hierarchy=1" >> /etc/default/grub
echo GRUB_CMDLINE_LINUX=\"cgroup_enable=memory swapaccount=1 cgroup_enable=memory use_hierarchy=1\" >> /etc/default/grub
update-grub
		# echo 1 > /sys/fs/cgroup/memory/memory.use_hierarchy
		 echo "DOCKER_OPTS=\"  -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --storage-driver=aufs  --dns 8.8.8.8  \"" > /etc/default/docker
	
	#for systemd
	
		if test -f /lib/systemd/system/docker.service
			then
			if test -f /bin/systemctl
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
				  
				if test -f /bin/systemctl
			 		then  
				   systemctl  daemon-reload
				  fi
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
		
		 echo "DOCKER_OPTS=\"-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock  --storage-driver=aufs --dns $ip --dns 8.8.8.8  \"" > /etc/default/docker
		
		 sleep 20
		 service docker start
		  
#stop appamour complaining about ptrace (caused be pas		  
 ln -s /etc/apparmor.d/docker /etc/apparmor.d/force-complain/ 
		  
  }
 