
function install_failed {

 echo please cd ../
 echo and sudo EnginesInstaller/obliterate_engines_no_warning.sh 
 exit -1
}

function create_db {

 toke=`dd if=/dev/urandom count=16 bs=1  | od -h | awk '{ print $2$3$4$6$6$7$8$9}'`
  cat ${top}/db.init | sed "/TOKEN/s//$toke/" |sqlite3 ~/db/production.sqlite3
  echo $toke > ~/.engines_token
}

function create_services {
echo "Creating and starting Engines Services"
create_db

mv /opt/engines/run/services-available/firstrun /opt/engines/run/services/

release=`cat /opt/engines/release`

echo "Downloading Registry image"
	docker pull engines/registry:$release >>/tmp/engines_install.log
	if test $? -ne 0
	 then
	  echo pull of engines/registry:$release failed check your network
	  install_failed
	fi
	
	
	CONTROL_IP=`/opt/engines/bin/system_ip.sh`
	export CONTROL_IP
	
	DOCKER_IP=`/opt/engines/bin/docker_ip.sh`
	export DOCKER_IP
	echo Docker IP $DOCKER_IP Control IP $CONTROL_IP
	
	/opt/engines/bin/system_service.rb registry create  >& /dev/null
	sleep 2
	docker start registry  >& /dev/null
	docker pull engines/system:$release >>/tmp/engines_install.log
	if test $? -ne 0
	 then
	  echo pull of engines/system:$release failed check your network
	  install_failed
	fi
	/opt/engines/bin/system_service.rb system create  >& /dev/null
	sleep 2
	docker start system  >& /dev/null
	sleep 5

	echo "System Services Started"
	
echo "Starting DNS"
echo "Downloading DNS image"
	docker pull engines/dns:$release >>/tmp/engines_install.log
	if test $? -ne 0
	 then
	  echo pull of engines/dns:$release failed check your network
	    install_failed
	fi
echo "Starting DNS"
	 /opt/engines/bin/engines service dns create >>/tmp/engines_install.log

#Do this so DNS gets sets as docker will not set dns on create to non functioning dns server
/opt/engines/bin/system_service.rb system stop >& /dev/null
/opt/engines/bin/system_service.rb system wait_for stop 10
/opt/engines/bin/system_service.rb system destroy  >& /dev/null
/opt/engines/bin/system_service.rb system wait_for destroy 10


/opt/engines/bin/system_service.rb registry stop  >& /dev/null
/opt/engines/bin/system_service.rb registry wait_for stop 10
/opt/engines/bin/system_service.rb registry destroy  >& /dev/null
/opt/engines/bin/system_service.rb registry wait_for destroy 10

/opt/engines/bin/system_service.rb registry create  >& /dev/null
/opt/engines/bin/system_service.rb registry wait_for create 10
docker start registry  >& /dev/null
/opt/engines/bin/system_service.rb registry wait_for start 20
/opt/engines/bin/system_service.rb registry wait_for_startup 10


/opt/engines/bin/system_service.rb system create  >& /dev/null
/opt/engines/bin/system_service.rb system wait_for create 10
docker  start system  >& /dev/null
/opt/engines/bin/system_service.rb system wait_for start 20
/opt/engines/bin/system_service.rb system wait_for_startup 15


/opt/engines/bin/engines service dns restart >& /dev/null
/opt/engines/bin/engines service dns wait_for start 20
echo "System services restarted"

echo "Downloading Syslog image"
	docker pull engines/syslog:$release >>/tmp/engines_install.log
 	if test $? -ne 0
 	 then
 	  echo pull of engines/syslog:$release failed check your network
 	    install_failed
 	fi
echo "Starting Syslog" 
	 /opt/engines/bin/engines service syslog create >>/tmp/engines_install.log
	 
echo "Downloading Avahi image"
	docker pull engines/avahi:$release >>/tmp/engines_install.log
 	if test $? -ne 0
 	 then
 	  echo pull of engines/avahi:$release failed check your network
 	    install_failed
 	fi

	  
echo "Downloading Cert Auth image"
	 docker pull engines/certs:$release >>/tmp/engines_install.log
 	if test $? -ne 0
 	 then
 	  echo pull of engines/certs:$release failed check your network
 	    install_failed
 	fi
echo "Starting Cert Auth"
	/opt/engines/bin/engines service  cert_auth create >>/tmp/engines_install.log
	
echo "Downloading MySQL image"
	 docker pull engines/mysql:$release >>/tmp/engines_install.log
 	if test $? -ne 0
 	 then
 	  echo pull of engines/mysql:$release failed check your network
 	    install_failed
 	fi
echo "Downloading Redis image"
	 docker pull engines/redis:$release >>/tmp/engines_install.log
 	if test $? -ne 0
 	 then
 	  echo pull of engines/mysql:$release failed check your network
 	    install_failed
 	fi
  
echo "Downloading First Run Wizard image"
	  docker pull engines/firstrun:$release >>/tmp/engines_install.log
	if test $? -ne 0
	 then
	  echo pull of engines/firstrun:$release failed check your network
	    install_failed
	fi
echo "Starting First Run Wizard "
	/opt/engines/bin/engines service firstrun create >>/tmp/engines_install.log
	
	
echo "Downloading Auth image"
	 docker pull engines/auth:$release >>/tmp/engines_install.log 
	if test $? -ne 0
	 then
	  echo pull of engines/auth:$release failed check your network
	    install_failed
	fi

echo "Downloading Web Router image"
	  docker pull engines/nginx:$release >>/tmp/engines_install.log
 	if test $? -ne 0
 	 then
 	  echo pull of engines/nginx:$release failed check your network
 	    install_failed
 	fi

	 
echo "Downloading Backup image"
	 docker pull engines/backup:$release >>/tmp/engines_install.log
 	if test $? -ne 0
 	 then
 	  echo pull of engines/backup:$release failed check your network
 	    install_failed
 	fi

	 
echo "Downloading Cron image"
	 docker pull engines/cron:$release >>/tmp/engines_install.log
 	if test $? -ne 0
 	 then
 	  echo pull of engines/cron:$release failed check your network
 	    install_failed
 	fi


echo "Downloading SMTP image"
	 docker pull engines/smtp:$release >>/tmp/engines_install.log
 	if test $? -ne 0
 	 then
 	  echo pull of engines/smtp:$release failed check your network
 	    install_failed
 	fi

  echo "Downloading mgmt image"
 	 
docker pull engines/mgmt:$release >>/tmp/engines_install.log
	  
echo "Downloading FTP image"
	docker pull engines/ftp:$release >>/tmp/engines_install.log
 	if test $? -ne 0
 	 then
 	  echo pull of engines/ftp:$release failed check your network
 	    install_failed
 	fi

	
echo "Downloading Volmanager image"
	docker pull engines/fs:$release >>/tmp/engines_install.log
	if test $? -ne 0
	 then
	  echo pull of engines/fs:$release failed check your network
	    install_failed
	fi
	
	docker pull engines/volbuilder:$release >>/tmp/engines_install.log
	

	
 docker pull engines/fsconfigurator:$release >>/tmp/engines_install.log


echo "Downloading Volmanager image"
	docker pull engines/logrotate:$release >>/tmp/engines_install.log

	
}