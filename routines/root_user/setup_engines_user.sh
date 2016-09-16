   function create_engines_user {
   echo "Creating for engines (shell) user"
  adduser -q --uid 21000  -gecos "Engines System User"  --home /home/engines --disabled-password engines
 #  passwd engines 
  
  }
 
 function configure_engines_user {
  echo "Configuring engines system user"
		mkdir -p /opt/engines/tmp/{container,service}
		chown -R engines /opt/engines/tmp
		
		  apt-get -y install g++ libssl-dev imagemagick libreadline-dev cmake  dc mysql-client libmysqlclient-dev unzip wget git  >>/tmp/engines_install.log
		 addgroup engines
		 addgroup -gid 22020 containers
		 usermod  -G containers -a engines
		  usermod  -G docker -a engines
		 usermod  -G engines -a engines
		  usermod -u 22015 backup
		  usermod  -a -G engines  backup
		  
		  if test -f ~/.ssh/authorized_keys
		   then
		   		mkdir -p ~engines/.ssh/
		   		chown engines ~engines/.ssh/
		   		cp ~/.ssh/authorized_keys ~engines/.ssh/
		   		chown engines  ~engines/.ssh/authorized_keys
		   		chmod og-rw ~engines/.ssh/authorized_keys
		   	fi
		   
		  chown engines /tmp/engines_install.log
		echo "PATH=\"/opt/engines/bin:$PATH\"" >>~engines/.profile 
		echo "export DOCKER_IP=`/opt/engines/bin/docker_ip.sh`" >>~engines/.profile 
		echo "export CONTROL_IP=`/opt/engines/bin/system_ip.sh`" >>~engines/.profile 
		
mkdir -p /etc/sudoers.d/
cp /opt/engines/system/updates/src/etc/sudoers.d/engines /etc/sudoers.d/engines
 cp /opt/engines/system/updates/src/etc/sudoers.d/engines_system /etc/sudoers.d/engines_system
chmod g-rw /etc/sudoers.d/engines 
chmod g-rw /etc/sudoers.d/engines_system 		

  }