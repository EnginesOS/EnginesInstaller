#!/bin/bash

function setup_service_definitions {
	cd /opt/engines/etc
	  if test -d services
		then
		  if test -d services.old
		    then
	 		  rm -r services.old
	 	  fi
		mv services services.old
	  fi
	  mkdir -p services/providers
	  cd services/providers
	  git clone https://github.com/EnginesServices/SumoLogic
	  cd SumoLogic
	  git checkout `cat /opt/engines/release`
	  cd ..
	  git clone https://github.com/EnginesServices/EnginesSystem
	  cd EnginesSystem
	   git checkout `cat /opt/engines/release`
	   cd ..
	#git clone https://github.com/EnginesOS/ServiceDefinitions services
	#cd services
	#git checkout `cat /opt/engines/release`
	cd ..
	make_service_mapping
}

function make_service_mapping {
	cd /opt/engines/etc/services

	mkdir  -p mapping
	cd mapping

	mkdir ManagedEngine
	mkdir -p database/sql/mysql
	mkdir -p database/sql/mysql
	mkdir -p filesystem/local/filesystem

	cd ../
	to_map="schedule ldap ldap_access auth cron backup avahi certs mongo pgsql mysql filesystem syslog dns wap logview logrotate"

	  for service in $to_map
	   do
		 service_def=`find providers/ -name ${service}.yaml`
		 echo service_def $service_def 
		  if ! test -z "$service_def"
		   then
		     #cp $service_def mapping/ManagedEngine
		     #?? mkdir -p `dirname 	mapping/ManagedEngine/$service_def`	     
		     ln -s /opt/engines/etc/services/$service_def mapping/ManagedEngine
		  fi
       done
    
	to_map="backup"

	  for service in $to_map
	    do
		  service_def=`find providers/ -name ${service}.yaml`
		  echo service_def  $service_def 
		  cp $service_def mapping/database/sql/mysql
		  cp $service_def mapping/database/sql/pgsql
		  cp $service_def mapping/filesystem/local/filesystem
       done
    
  	to_map="ftp"

	  for service in $to_map
	    do
		  service_def=`find providers/ -name ${service}.yaml`
		  echo service_def  $service_def 
		  cp $service_def mapping/filesystem/local/filesystem
       done      
}
    