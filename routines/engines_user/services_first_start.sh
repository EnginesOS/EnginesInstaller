
function install_failed {

 echo please cd ../
 echo and sudo EnginesInstaller/obliterate_engines_no_warning.sh 
 exit -1
}

function create_services {
echo "Creating and starting Engines Services"


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
	
	/opt/engines/bin/system_service.rb registry create
	
	docker pull engines/system:$release >>/tmp/engines_install.log
	if test $? -ne 0
	 then
	  echo pull of engines/system:$release failed check your network
	  install_failed
	fi
	/opt/engines/bin/system_service.rb system create
	sleep 60 
	/opt/engines/bin/engines system login admin EnginesDemo > ~engines/.engines_token
	
	
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
echo "Starting Avahi"
	 /opt/engines/bin/engines service avahi create >>/tmp/engines_install.log
	  
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
echo "Starting MySQL"	 
	 /opt/engines/bin/engines service  mysql_server create >>/tmp/engines_install.log
	  
echo "Downloading First Run Wizard  image"
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
echo "Starting Auth"
	 /opt/engines/bin/engines service auth create  >>/tmp/engines_install.log
	 
echo "Downloading Web Router image"
	  docker pull engines/nginx:$release >>/tmp/engines_install.log
	if test $? -ne 0
	 then
	  echo pull of engines/nginx:$release failed check your network
	    install_failed
	fi
echo "Starting Web Router"
	 /opt/engines/bin/engines service nginx create >>/tmp/engines_install.log
	 
echo "Downloading Backup image"
	 docker pull engines/backup:$release >>/tmp/engines_install.log
	if test $? -ne 0
	 then
	  echo pull of engines/backup:$release failed check your network
	    install_failed
	fi
echo "Starting Backup"
	 /opt/engines/bin/engines service backup create >>/tmp/engines_install.log
	 
echo "Downloading Cron image"
	 docker pull engines/cron:$release >>/tmp/engines_install.log
	if test $? -ne 0
	 then
	  echo pull of engines/cron:$release failed check your network
	    install_failed
	fi
 echo "Starting Cron"
	 /opt/engines/bin/engines service cron create >>/tmp/engines_install.log
 	 

echo "Downloading SMTP image"
	 docker pull engines/smtp:$release >>/tmp/engines_install.log
	if test $? -ne 0
	 then
	  echo pull of engines/smtp:$release failed check your network
	    install_failed
	fi
 echo "Starting SMTP"
	 /opt/engines/bin/engines service smtp create >>/tmp/engines_install.log
 	 

	  
echo "Downloading FTP image"
	docker pull engines/ftp:$release >>/tmp/engines_install.log
	if test $? -ne 0
	 then
	  echo pull of engines/ftp:$release failed check your network
	    install_failed
	fi
echo "Starting FTP"
	 /opt/engines/bin/engines service  ftp create >>/tmp/engines_install.log
 	
	
echo "Downloading Volmanager image"
	docker pull engines/fs:$release >>/tmp/engines_install.log
	if test $? -ne 0
	 then
	  echo pull of engines/fs:$release failed check your network
	    install_failed
	fi
	
	docker pull engines/volbuilder:$release
	
echo "Starting Volmanager image"
	//opt/engines/bin/engines service volmanager create >>/tmp/engines_install.log
	
 docker pull engines/fsconfigurator:$release

	
echo "Starting System Services"
	# /opt/engines/bin/engines containers  check_and_act  >>/tmp/engines_install.log &
	 
	# docker pull engines/mgmt:$release
	
}