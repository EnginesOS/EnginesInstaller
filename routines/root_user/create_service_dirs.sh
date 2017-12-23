function setup_dirs {
	mkdir -p  /var/log/engines/services/$service
	mkdir -p /opt/engines/run/services/$service/run
	mkdir -p /var/lib/engines/services/$service
	owner=`/opt/engines/system/scripts/system/get_service_uid.sh $service`
	chown -R $owner /var/log/engines/services/$service /opt/engines/run/services/$service/run /var/lib/engines/services/$service
}
function make_dirs {
	setup_fs_dir
	setup_log_dir
	setup_system_dirs
	setup_cert_auth_dirs
	copy_install_ssl_cert
	
	setup_syslog_dirs
	setup_auth_dirs
	setup_mgmt_dirs
	setup_nginx_dirs
	setup_mysql_dirs
	setup_pqsql_dirs 
	setup_smtp_dirs
	setup_backup_dirs
	setup_dns_dirs
	setup_imap_dirs
	setup_ftp_dirs
	setup_mongo_dirs	
	setup_cron_dirs
	setup_email_dirs
	setup_nfs_dirs	
	setup_run_dirs
	setup_key_dirs
	
	chown 21000 -R /opt/engines/run/services-available/
	/opt/engines/bin/set_service_provider.sh syslog EnginesSystem
	
	mkdir -p /opt/engines/run//utilitys/fsconfigurator/ /var/log/engines//utilitys/fsconfigurator
	chown -R 21000 /opt/engines/run/utilitys/fsconfigurator/ /var/log/engines//utilitys/

	

	touch /var/lib/engines/local_host
}

function setup_key_dirs {
	mkdir -p /opt/engines/etc/ssh/keys/apps
	mkdir -p /opt/engines/etc/ssh/keys/services
	mkdir -p /opt/engines/etc/ssh/keys/system_services
	mkdir -p /opt/engines/etc/ssh/keys/utilitys
	chown -R 21000 /opt/engines/etc/ssh/keys/
}

function setup_system_dirs {
	mkdir -p  /var/log/engines/system_services/system/
	mkdir -p   /opt/engines/run/system_services/system/run
	chown 21000 /opt/engines/run/system_services/system/run /var/log/engines/system_services/system/
}

function setup_nfs_dirs {
	echo "Creating NFS Service Dirs"
	service=nfs
	setup_dirs
}

function setup_mgmt_dirs {
	echo "Creating Management Service Dirs"
	service=control
	setup_dirs	
}
		
function setup_system_dirs {
	echo "Creating System Service Dirs"
	mkdir -p  /home/engines/db 
	
	touch /home/engines/db/production.sqlite3
	chown 21000 /home/engines/db/production.sqlite3
	chmod og-rwx /home/engines/db/production.sqlite3

	mkdir -p /home/engines/deployment/deployed/
	mkdir -p  /var/lib/engines/control/public/system/
	mkdir -p /home/engines/.ssh/system/
	
	mkdir -p /opt/engines/etc/ssh/keys/services/control
	chmod og-w /opt/engines/etc/ssh/keys/services/control
	chmod o-r /opt/engines/etc/ssh/keys/services/control
	chown 21000  /opt/engines/etc/ssh/keys/services/control
	
	mkdir -p /var/log/engines/system_services/system/
	chown -R 21000  /var/log/engines/system_services/system/
	
	mkdir -p  /opt/engines/run/system_services/system/run/
	chown -R 21000  /opt/engines/run/system_services/system/run/
	chgrp containers  -R /opt/engines/run/system_services/system
	
	mkdir -p /opt/engines/run/service_manager/
	mkdir -p /var/log/engines/updates/ 
	chown -R 21000 /opt/engines/run/service_manager/
	chown -R 21000 /home/engines/deployment/deployed/
	chown 21000 /var/lib/engines  /var/log/engines/apps /var/log/engines/ /var/log/engines/updates/ /var/log/engines/services/
	
	chown -R 21000 ~engines/  /var/lib/engines/control/public/system/ 

	
	mkdir -p /opt/engines/run/system/flags/
	chown -R 21000 /opt/engines/run/system/
	
	mkdir -p /opt/engines/system/updates/failed/engines
	mkdir -p /opt/engines/system/updates/has_run/engines
	mkdir -p /opt/engines/system/updates/to_run/engines
	
	chown -R 21000 /opt/engines/system/updates/failed/engines /opt/engines/system/updates/has_run/engines /opt/engines/system/updates/to_run/engines
	
	mkdir -p /opt/engines/system/updates/failed/system
	mkdir -p /opt/engines/system/updates/has_run/system
	mkdir -p /opt/engines/system/updates/to_run/system

}


function setup_nginx_dirs {
	echo "Setting up Nginx"
	service=wap
	setup_dirs
	
}

function setup_avahi_dirs {
	echo "Setup Avahi "
	service=avahi
	setup_dirs
}

function setup_mysql_dirs {
	echo "Creating MySQL Service Dirs"
	service=mysqld
	setup_dirs	
}

function setup_fs_dir {
	echo "Creating FS Dirs"
	mkdir -p  /var/lib/engines/apps/
	chown -R 21000 /var/lib/engines   
}

function setup_log_dir {
	echo "Creating Log Dirs"
	mkdir -p /var/log/engines
	mkdir -p /var/log/engines/raw
	mkdir -p /var/log/engines/apps/
	mkdir -p /var/log/engines/services/
	chown -R 21000 /var/log/engines 
}

function setup_syslog_dirs {
	mkdir -p /var/lib/engines/services/syslog/rmt
	service=syslog
	setup_dirs
}

function setup_pqsql_dirs {
	service=pgsqld
	setup_dirs
}

function setup_smtp_dirs {
	echo "Setting up SMTP "
	service=smtp
	setup_dirs
 	
}

function setup_backup_dirs {
 	echo "Setting up Backup "
 	mkdir -p  /var/log/engines/services/backup
 	mkdir -p  /var/lib/engines/backup_paths
 	chown 22015 /var/lib/engines/backup_paths/
 	chown 22015 /var/log/engines/services/backup/
 	mkdir -p /opt/engines/etc/backup/configs
 	chown 22015 /opt/engines/etc/backup/configs
 	mkdir -p /opt/engines/etc/backup/keys/
 	chown 22015 /opt/engines/etc/backup/keys/ 
 	service=backup
	setup_dirs
}
 
function setup_dns_dirs {
	echo "Setting up DNS "
	service=dns
	setup_dirs 
}
 
function setup_imap_dirs {
 	echo "Setting up Imap "
 	mkdir -p /var/lib/engines/services/imap/lib
	mkdir -p /var/lib/engines/services/imap/mail
	service=imap
	setup_dirs 
}
 
function setup_ftp_dirs {
	echo "Setting up FTP "
 	service=ftp
  	setup_dirs
}
 
function setup_mongo_dirs {
	echo "Setting up Mongo " 	
 	service=mongod
  	setup_dirs
}
 
function setup_cert_auth_dirs {
 	echo "Setting up Cert Auth "
	mkdir -p /var/lib/engines/services/certs/store/private/ca/keys
	mkdir -p /var/lib/engines/services/certs/store/public/certs
	mkdir -p /var/lib/engines/services/certs/store/public/certs
	mkdir -p /var/lib/engines/services/certs/store/public/ca/certs/
	mkdir -p /var/lib/engines/services/certs/store/public/ca/keys
	mkdir -p /var/lib/engines/services/certs/store/public/certs/system/system/
	mkdir -p /var/lib/engines/services/certs/store/public/certs/system/registry
	mkdir -p /var/lib/engines/services/certs/store/public/keys/system/system/

	#empty file as CA so mapped by dockers as a file and not an auto create dir
	touch /var/lib/engines/services/certs/store/public/ca/certs/system_CA.pem
	cert_uid=`/opt/engines/system/scripts/system/get_service_uid.sh  certs`
	chown -R $cert_uid /var/lib/engines/services/certs/ 
		
  	service=certs
  	setup_dirs
} 

function setup_auth_dirs {
  	echo "Setting up Auth " 	
  	service=auth
  	setup_dirs
 }

function setup_cron_dirs {
	echo "Setting up Cron Dirs"
	service=cron
 	setup_dirs
}
 
function setup_run_dirs {
  	echo "Setting up Run Dirs"
  #	mkdir /opt/engines/run/apps/
    chown 21000 /opt/engines/run/services/ /opt/engines/run/apps/
 	chgrp -R 22020 /opt/engines/run/services/
	chmod g+w -R  /opt/engines/run/services/
	chgrp containers /opt/engines/run/services/*/run
	chmod g+w /opt/engines/run/services/*/run
	mkdir /opt/engines/run/cid
	chown 21000 /opt/engines/run/cid
	chown 21000 -R /opt/engines/run/services/
	chown 21000 -R /opt/engines/run/apps/
	mkdir -p /opt/engines/etc/domains/
	chown 21000 -R /opt/engines/etc/domains/
	mkdir -p /opt/engines/etc/exported/net/  
	chown 21000 -R /opt/engines/etc/exported/net  
	mkdir -p /opt/engines/run/system/flags/
	chown 21000 /opt/engines/run/system/
	mkdir -p /opt/engines/etc/preferences/
	chown 21000 -R /opt/engines/etc/preferences/	
	mkdir -p /var/lib/engines/registry
	chown -R 22023 /var/lib/engines/registry
	mkdir -p /var/log/engines/system_services/registry
	chown -R 22023 /var/log/engines/system_services/registry
	mkdir -p /opt/engines/run//system_services/registry/run
	chown -R 21000  /opt/engines/run/system_services/
	chown -R 22023.containers  /opt/engines/run/system_services/registry/run	
}
	 
 function setup_email_dirs {
   	echo "Setting up Email Dirs"  	
  	service=email
  	setup_dirs
}
 