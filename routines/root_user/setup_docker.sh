
#packages="apt-transport-https  aufs-tools libreadline-dev  linux-image-extra-$(uname -r) lvm2 thin-provisioning-tools openssh-server haveged"


function install_docker_components {

	dmesg |grep -i Xen >/dev/null
	  if test $? -eq 0
 		then
 		   echo Xen Detected
 		   XEN=yes
			ln -s /dev/null /etc/udev/rules.d/40-vm-hotadd.rules
 	  fi
 
 
 	dmesg |grep amazon>/dev/null
	  if test $? -eq 0
 	   then
 	      echo AWS Detected
 	      AWS=yes
      fi
 
	/usr/sbin/addgroup --gid 909 docker

	packages=`cat ${top}/packages`

	  for package in $packages
 	    do
 	 	   dpkg -s $package |grep Status |grep installed
 	 	   #apt list $package  |grep installed 
 	 	     if test $? -ne 0
 	  		   then
 	 		      packages_to_install="$packages_to_install $package"
 	         fi
         done

	echo $packages_to_install >/opt/engines/system/packages_installed
  	echo "Installing Docker"		
  	 apt-get install -y linux-image-extra-$(uname -r)  >>/tmp/engines_install.log
       if ! test -z "$packages_to_install"
         then
		    apt-get install -y $packages_to_install >>/tmp/engines_install.log
       fi
	grep UBUNTU_CODENAME=xenial /etc/os-release >/dev/null
      if test $? -eq 0
       then
       	echo "setting up for xenial"
		echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" |  tee /etc/apt/sources.list.d/docker.list
		apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
		apt-get update
		apt-get -y   install docker-engine >>/tmp/engines_install.log
      else
		 grep UBUNTU_CODENAME=bionic /etc/os-release >/dev/null
		  if test $? -eq 0
                   then
			apt-get -y install docker.io

		else
		 echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
		 wget -qO- https://get.docker.io/gpg | apt-key add - >>/tmp/engines_install.log
		 apt-get update
		 apt-get -y  install docker-containerd >>/tmp/engines_install.log
	   fi
	  fi
		 
	apt-get -y update >>/tmp/engines_install.log
	apt-get -y upgrade
	#if virutal
 	apt-get upgrade -y linux-headers-generic linux-headers-virtual linux-image-virtual  linux-virtual  linux-image-extra-$(uname -r) aufs-tools 
 	#else
 	# apt-get upgrade -y linux-headers-generic linux-headers-virtual linux-image-virtual  linux-virtual  linux-image-extra-$(uname -r) 
	update-rc.d docker defaults 
	service docker start
	systemctl  disable avahi-daemon	
}

function configure_docker {
	echo "Configuring Docker DNS settings"	 
	mkdir -p /opt/engines/system/uninstall/etc/default/
    cp -p /etc/default/grub /opt/engines/system/uninstall/
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
		ip=`ifconfig docker0  |grep "inet"  |awk '{print $2}' |head -1`
		cat ${top}/install_source/lib/systemd/system/docker.service | sed "s/IP/$ip/" > /lib/systemd/system/docker.service
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
		
	 echo "DOCKER_OPTS=\" -H unix:///var/run/docker.sock  --storage-driver=aufs --dns $ip --dns 8.8.8.8  \"" > /etc/default/docker
		
	sleep 20
	service docker start
	  
#stop appamour complaining about ptrace (caused be pas		
		if ! test -f   /etc/apparmor.d/force-complain/docker
 		  then
 			 ln -s /etc/apparmor.d/docker /etc/apparmor.d/force-complain/
 		fi 
		  
		#  chgrp edocker /var/run/docker.sock
}
 
