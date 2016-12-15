
function make_dirs {

	setup_fs_dir
	setup_log_dir
	setup_system_dirs
	setup_cert_auth_dirs
	copy_install_ssl_cert
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
	chown 21000 -R /opt/engines/run/services-available/
	/opt/engines/bin/set_service_provider.sh syslog EnginesSystem
	
	mkdir -p /opt/engines/run//utilities/fsconfigurator/
	chown 21000 /opt/engines/run//utilities/fsconfigurator/
	mkdir -p /var/lib/engines/mgmt/public/
	chown -R 22050 /var/lib/engines/mgmt/public/
}
function setup_system_dirs {
	mkdir -p  /var/log/engines/system_services/system/
	mkdir -p   /opt/engines/run/system_services/system/run
	chown 21000 /opt/engines/run/system_services/system/run /var/log/engines/system_services/system/
}
function setup_nfs_dirs {
echo "Creating NFS Service Dirs"
mkdir -p  /var/log/engines/services/nfs/
}

function setup_mgmt_dirs {
	echo "Creating Management Service Dirs"
	mkdir -p  /var/log/engines/services/mgmt
	chown -R 22050 /var/log/engines/services/mgmt 
	mkdir -p  /opt/engines/run//services/mgmt/run
	chown -R 22050 /opt/engines/run//services/mgmt/run
	
		}
function setup_system_dirs {
echo "Creating System Service Dirs"
	mkdir -p  /home/engines/db 
	
	touch /home/engines/db/production.sqlite3
	chown 21000 /home/engines/db/development.sqlite3
	chmod og-rwx /home/engines/db/development.sqlite3

	mkdir -p /home/engines/deployment/deployed/
	mkdir -p  /var/lib/engines/mgmt/public/system/
	mkdir -p /home/engines/.ssh/mgmt/
	mkdir -p /opt/engines/etc/ssh/keys/services/mgmt
	chmod og-w /opt/engines/etc/ssh/keys/services/mgmt
	chmod o-r /opt/engines/etc/ssh/keys/services/mgmt
	chown 21000  /opt/engines/etc/ssh/keys/services/mgmt
	#chown 21000  /home/engines/db/production.sqlite3
	#chown 21000  /home/engines/db/development.sqlite3
	
	#chown -R 21000 /home/engines/db/
	mkdir -p /var/log/engines/system_services/system/
	chown -R 21000  /var/log/engines/system_services/system/
	
	mkdir -p  /opt/engines/run/system_services/system/run/
	chown -R 21000  /opt/engines/run/system_services/system/run/
	chgrp containers  -R /opt/engines/run/system_services/system
	
	mkdir -p /opt/engines/run/service_manager/
	mkdir -p /var/log/engines/updates/ 
	chown -R 21000 /opt/engines/run/service_manager/
	chown -R 21000 /home/engines/deployment/deployed/
	chown 21000 /var/lib/engines  /var/log/engines/containers  /var/log/engines/ /var/log/engines/updates/ /var/log/engines/services/ /var/log/engines/containers/
	
	chown -R 21000 ~engines/  /var/lib/engines/mgmt/public/system/ 

	
	mkdir -p /opt/engines/run/system/flags/
	chown -R 21000 /opt/engines/run/system/
	
	mkdir -p /opt/engines/system/updates/failed/engines
	mkdir -p /opt/engines/system/updates/has_run/engines
	mkdir -p /opt/engines/system/updates/to_run/engines
	
	chown -R 21000 /opt/engines/system/updates/failed/engines /opt/engines/system/updates/has_run/engines /opt/engines/system/updates/to_run/engines
	
	mkdir -p /opt/engines/system/updates/failed/system
	mkdir -p /opt/engines/system/updates/has_run/system
	mkdir -p /opt/engines/system/updates/to_run/system
	
	mkdir -p  /opt/engines/etc/ssh/keys
	chown -R 21000 /opt/engines/etc/ssh/keys
}


function setup_nginx_dirs {
	echo "Setting up Nginx "
	mkdir -p  /var/log/engines/services/nginx/nginx
	mkdir -p /opt/engines/run/services/nginx/run/nginx/
	chown -R 22005.22005 /var/log/engines/services/nginx /opt/engines/run/services/nginx/run/nginx
}

function setup_avahi_dirs {
	echo "Setup Avahi "
	mkdir -p  /var/log/engines/services/avahi
	mkdir -p /opt/engines/run/services/avahi/run
	chown -R 22026.22026 /var/log/engines/services/avahi /opt/engines/run/services/avahi/run/
}

function setup_mysql_dirs {
	echo "Creating MySQL Service Dirs"
	mkdir -p  /var/lib/engines/mysql 
	mkdir -p /var/log/engines/services/mysql/
	mkdir -p  /opt/engines/run/services/mysql_server/run/mysqld
		chown -R 22006.22006  /var/lib/engines/mysql /var/log/engines/services/mysql/ /opt/engines/run/services/mysql_server/run/mysqld	
}

function setup_fs_dir {
echo "Creating FS Dirs"
mkdir -p  /var/lib/engines/
mkdir -p  /var/lib/engines/fs/

chown -R 21000 /var/lib/engines   

}
function setup_log_dir {
echo "Creating Log Dirs"
mkdir -p  /var/log/engines
mkdir -p /var/log/engines/raw
mkdir -p /var/log/engines/containers/
chown -R 21000 /var/log/engines 
mkdir -p /var/log/engines/services/syslog/rmt
chown  22012 -R  /var/log/engines/services/syslog


}

function setup_pqsql_dirs {
echo "Setting up PostgreSQL"
mkdir -p  /var/lib/engines/pgsql
mkdir -p  /var/log/engines/services/pgsql/
mkdir -p  /opt/engines/run/services/pgsql_server/run/postgres
mkdir -p /opt/engines/etc/pgsql/ssl
cp -r /var/lib/engines/cert_auth/public/certs /opt/engines/etc/pgsql/ssl
cp -r /var/lib/engines/cert_auth/public/keys /opt/engines/etc/pgsql/ssl/private
chown -R 22002 /opt/engines/etc/pgsql/ssl
chmod og-rw -R /opt/engines/etc/pgsql/ssl
chown -R 22002.22002	/var/lib/engines/pgsql /var/log/engines/services/pgsql	/opt/engines/run/services/pgsql_server/run/postgres

}
function setup_smtp_dirs {
 echo "Setting up SMTP "
mkdir -p /var/log/engines/services/smtp/
mkdir -p /opt/engines/etc/smtp/ssl/
cp -r /var/lib/engines/cert_auth/public/certs /opt/engines/etc/smtp/ssl
cp -r /var/lib/engines/cert_auth/public/keys /opt/engines/etc/smtp/ssl
 chown 22003 -R /var/log/engines/services/smtp/ /opt/engines/etc/smtp/ssl 
 chmod og-rw -R /opt/engines/etc/smtp/ssl/keys/
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
 
 }
 
 function setup_dns_dirs {
 echo "Setting up DNS "
 	mkdir -p  /var/log/engines/services/dns/
 	mkdir -p /opt/engines/run/services/dns/run/dns
 	chown -R 22009.22009 /opt/engines/run/services/dns/run/dns /var/log/engines/services/dns/
 }
 
 function setup_imap_dirs {
 	echo "Setting up Imap "
 	mkdir -p /var/lib/engines/imap/lib
	mkdir -p /var/lib/engines/imap/mail
	mkdir -p /opt/engines/etc/imap/ssl
	cp -r /var/lib/engines/cert_auth/public/certs /opt/engines/etc/imap/ssl
	cp -r /var/lib/engines/cert_auth/public/keys /opt/engines/etc/imap/ssl
	chown -R 22013 /var/lib/engines/imap
	chown -R 22013 /opt/engines/etc/imap/ssl
	chmod og-rw -R /opt/engines/etc/imap/ssl
	
 }
 
 function setup_ftp_dirs {
 echo "Setting up FTP "
  mkdir -p  /var/log/engines/services/ftp/proftpd /opt/engines/etc/ftp/ssl
 chown -R 22010 /var/log/engines/services/ftp
 cp -r /var/lib/engines/cert_auth/public/certs /opt/engines/etc/ftp/ssl
cp -r /var/lib/engines/cert_auth/public/keys /opt/engines/etc/ftp/ssl
 chown -R 22010 /opt/engines/etc/ftp/ssl
 chmod og-rw -R /opt/engines/etc/ftp/ssl
 
 }
 function setup_mongo_dirs {
 echo "Setting up Mongo "
 mkdir -p /var/lib/engines/mongo /var/log/engines/services/mongo_server	/opt/engines/run/services/mongo_server/run/mongo/
 chown -R 22008.22008 /var/lib/engines/mongo /var/log/engines/services/mongo_server	/opt/engines/run/services/mongo_server/run/mongo/
 }
 
 function setup_cert_auth_dirs {
 echo "Setting up Cert Auth "

 mkdir -p /var/lib/engines/cert_auth/private/ca/keys
 mkdir -p /var/lib/engines/cert_auth/public/certs
 mkdir -p /var/lib/engines/cert_auth/public/certs

mkdir -p  /var/log/engines/services/cert_auth/

mkdir -p /opt/engines/etc/certs/engines/
mkdir -p /opt/engines/etc/certs/ca
chown -R 22022 /var/lib/engines/cert_auth/ /opt/engines/etc/certs/ /var/log/engines/services/cert_auth/
 } 

 function setup_auth_dirs {
  echo "Setting up Auth "
mkdir -p /opt/engines/etc/auth/keys/
mkdir -p /var/lib/engines/auth/
mkdir -p /var/log/engines/services/auth/ 
mkdir -p /opt/engines/etc/auth/access  /opt/engines/etc/auth/scripts  /opt/engines/etc/auth/keys
	chown 22017 -R /var/log/engines/services/auth/ /var/lib/engines/auth/
	chown -R 22017 /opt/engines/etc/auth/scripts
	chown -R 22017 /opt/engines/etc/auth/access
	chown 22017 -R  /opt/engines/etc/auth/keys/
 }
 function setup_cron_dirs {
   echo "Setting up Cron Dirs"
 mkdir -p /var/log/engines/services/cron 
 chown -R  22016 /var/log/engines/services/cron

 }
 
 function setup_run_dirs {
  echo "Setting up Run Dirs"
   chown 21000 /opt/engines/run/services/ /opt/engines/run/containers/
 	chgrp -R 22020 /opt/engines/run/services/
	chmod g+w -R  /opt/engines/run/services/
	 chgrp containers /opt/engines/run/services/*/run
	 chmod g+w /opt/engines/run/services/*/run
	 chown root /opt/engines/etc/auth/
	  mkdir /opt/engines/run/cid
	  chown 21000 /opt/engines/run/cid
	 chown 21000 -R /opt/engines/run/services/
	 chown 21000 -R /opt/engines/run/containers/
	 mkdir -p /opt/engines/etc/domains/
	 chown 21000 -R /opt/engines/etc/domains/
	 	 mkdir -p /opt/engines/etc/net/  
	  chown 21000 -R /opt/engines/etc/net/  
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
 mkdir -p /var/log/engines/services/email/apache2 /opt/engines/etc/email/ssl
 chown 22003 -R /var/log/engines/services/email/
  cp -r /var/lib/engines/cert_auth/public/certs /opt/engines/etc/email/ssl
cp -r /var/lib/engines/cert_auth/public/keys /opt/engines/etc/email/ssl
  chown 22003 -R /opt/engines/etc/email/ssl
 }
 