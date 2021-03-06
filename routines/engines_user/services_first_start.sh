


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

function create_service {
echo "Starting $service"
	
	 echo "Starting $service"
	 /opt/engines/bin/engines service $service create >>/tmp/engines_install.log
}

function pull_image {
	echo "Downloading $image engines/$image:$release"
	docker pull engines/$image:$release >>/tmp/engines_install.log
		if test $? -ne 0
	      then
	  		echo pull of engines/$image:$release failed check your network
	    	install_failed
		fi
}

function create_system_service {
    /opt/engines/bin/system_service.rb $system_service create 
	/opt/engines/bin/system_service.rb $system_service wait_for create 126	
	docker start $system_service  >& /dev/null
	/opt/engines/bin/system_service.rb $system_service wait_for start 120
	/opt/engines/bin/system_service.rb $system_service wait_for_startup 134
}

function destroy_system_service {
	/opt/engines/bin/system_service.rb $system_service stop >& /dev/null
	/opt/engines/bin/system_service.rb $system_service wait_for stop 120
	/opt/engines/bin/system_service.rb $system_service destroy  >& /dev/null
	/opt/engines/bin/system_service.rb $system_service wait_for destroy 120
}



function create_services {
	echo "Creating and starting Engines Services"
	create_db	
	
	cp -r /opt/engines/run/services-available/firstrun /opt/engines/run/services/

	release=`cat /opt/engines/release`
	

	echo Docker IP $DOCKER_IP Control IP $CONTROL_IP
	
	image=registry
	pull_image
	system_service=registry
	create_system_service

	image=system
	pull_image
	system_service=system	
	create_system_service
	echo "System Services Started"
	
	image=dns
	pull_image
	
	service=dns
	create_service

	#Do this so DNS gets sets as docker will not set dns on create to non functioning dns server
	system_service=system
	destroy_system_service
	system_service=registry
	destroy_system_service
	
	create_system_service	
	system_service=system
	create_system_service
	
	/opt/engines/bin/engines service dns restart >& /dev/null
	/opt/engines/bin/engines service dns wait_for start 20
	echo "System services restarted"
	
images=`cat ${top}/init_services`
images="syslog\
 			avahi\
 			certs\
 			mysql\
 			redis\
 			firstrun\
 			auth\
 			wap \
 			backup \
 			cron \
 			ldap \
 			smtp \
 			uadmin \
 			fs \
 			logrotate \
 			volbuilder \
 			ftp \
 			fsconfigurator"
 			
 for image in $images
  do 
	pull_image
  done
   			

 for service in syslog certs firstrun
  do 
	create_service
  done



}