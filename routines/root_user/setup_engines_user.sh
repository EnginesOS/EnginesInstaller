   function create_engines_user {
   echo "Creating for engines (shell) user"
  adduser -q --uid 21000  -gecos "Engines System User"  --home /home/engines --disabled-password engines
 #  passwd engines 
  
  }
  
    function create_engssrc_user {
   echo "Creating for engines source owner"
  adduser -q  -gecos "Engines Src Owner"  --home /home/engsrc --disabled-password engsrc  
  } 
  
 
 function configure_engines_user {
  	echo "Configuring engines system user"
	mkdir -p /opt/engines/tmp/{container,service}
	chown -R engines /opt/engines/tmp
	 mkdir /opt/engines/etc/debug/
	chown  -R engines /opt/engines/etc/debug/
	
	apt-get -y install g++ libssl-dev imagemagick libreadline-dev cmake  dc mysql-client libmysqlclient-dev unzip wget git  >>/tmp/engines_install.log
	addgroup engines
	addgroup -gid 22020 containers
	usermod  -G containers -a engines
	usermod  -G docker -a engines
	usermod  -G engines -a engines
	usermod -u 22015 backup
	usermod  -a -G engines  backup
	  
	touch ~engines/.engines_token
	chown engines ~engines/.engines_token
	chmod 600 ~engines/.engines_token
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