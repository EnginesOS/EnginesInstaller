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
git clone https://github.com/EnginesOS/ServiceDefinitions services
cd services
git checkout `cat /opt/engines/release`

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
to_map="cron backup avahi mongo pgsql mysql filesystem syslog dns nginx logview log_rotate"

for service in $to_map
	do
		service_def=`find providers/ -name ${service}.yaml`
		echo service_def  $service_def 
		cp $service_def mapping/ManagedEngine
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
    