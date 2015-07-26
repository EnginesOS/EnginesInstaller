#!/bin/bash
RUBY_VER=2.2.2
#*******************************************************************************
# Copyright (c) 2015 P3Nominees.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
#*******************************************************************************




function configure_git {
	echo "Installing base Engines System"
	apt-get install -y git	>>/tmp/engines_install.log
	mkdir -p /opt/	
	git clone https://github.com/EnginesOS/System.git --branch $branch  --single-branch /opt/engines/ 	>>/tmp/engines_install.log
	echo $branch > /opt/engines/release


}
  function create_engines_user {
   echo "Creating for engines (shell) user"
  adduser -q --uid 21000  -gecos "Engines System User"  --home /home/engines --disabled-password engines
 #  passwd engines 
  
  }
  function update_os {
   echo "updating OS to Latest"
  apt-get -y  --force-yes update >>/tmp/engines_install.log
  
  #Perhaps Not something we should do as can ask grub questions and will confuse no techy on aws
  apt-get -y  upgrade  >>/tmp/engines_install.log
  }
  
  function setup_startup_script {
  echo "Adding startup script"
		 cat /etc/rc.local | sed "/^exit.*$/s//su -l engines \/opt\/engines\/bin\/engines_startup.sh/" > /tmp/rc.local
		 echo "exit 0"  >> /tmp/rc.local
		 cp /tmp/rc.local /etc/rc.local
		 rm  /tmp/rc.local
		
		 chmod u+x  /etc/rc.local
  }
  
  function install_docker_components {
  echo "Installing Docker"		
		 apt-get install -y apt-transport-https  libreadline-dev  linux-image-extra-$(uname -r) lvm2 thin-provisioning-tools openssh-server >>/tmp/engines_install.log
		 echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
		 apt-get -y update >>/tmp/engines_install.log
 
	
		 wget -qO- https://get.docker.io/gpg | apt-key add - >>/tmp/engines_install.log
		 apt-get -y  --force-yes install lxc-docker >>/tmp/engines_install.log
		 update-rc.d docker defaults 
		 service docker start
  }
  
  function configure_docker {
  echo "Configuring Docker DNS settings"	 
		# echo "DOCKER_OPTS=\"--storage-driver=devicemapper --dns  172.17.42.1 --dns 8.8.8.8  --bip=172.17.42.1/16\"" >> /etc/default/docker
		 echo "DOCKER_OPTS=\" --storage-driver=aufs --dns  172.17.42.1 --dns 8.8.8.8  --bip=172.17.42.1/16\"" >> /etc/default/docker
	
	#for systemd
		if test -f /lib/systemd/system/docker.service
			then
				cp ${top}/install_source/lib/systemd/system/docker.service /lib/systemd/system/docker.service
			fi
		 update-rc.d docker defaults 
		 service docker start	
		  if test -f /bin/systemctl
		  then
		 	systemctl enable docker
		 fi
		 
		 #need to restart to get dns set
		 service docker stop
		 sh -c echo 1 \> /sys/fs/cgroup/memory/memory.use_hierarchy
		 sleep 20
		 service docker start
		  
  }
  function configure_engines_user {
  echo "Configuring engines system user"
		
		  apt-get -y install libssl-dev  imagemagick cmake  dc mysql-client libmysqlclient-dev unzip wget git  >>/tmp/engines_install.log
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
		
mkdir -p /etc/sudoers.d/
cp ${top}/install_source/etc/sudoers.d/engines /etc/sudoers.d/engines 
		
  }
  
  function install_rbenv {
  echo "Installing rbenv"


mkdir -p /usr/local/  
cd /usr/local/  
git clone git://github.com/sstephenson/rbenv.git /usr/local/rbenv >>/tmp/engines_install.log

	chgrp -R engines rbenv
	chmod -R g+rwxXs rbenv
	
	cd /usr/local/rbenv   

	git clone git://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build  >>/tmp/engines_install.log
	chgrp -R engines plugins/ruby-build
	chmod -R g+rwxs plugins/ruby-build
	
	echo 'export PATH="/usr/local/rbenv/bin:$PATH"' >> ~/.bashrc 
	echo 'eval "$(rbenv init -)"' >> ~/.bashrc ; .  ~/.bashrc
	source ~/.bashrc 
	 
	echo 'export PATH="/usr/local/rbenv/bin:$PATH"' >> ~engines/.profile
	 echo 'export PATH="/usr/local/rbenv/bin:$PATH"' >> ~engines/.bashrc
	echo 'eval "$(rbenv init -)"' >> ~engines/.profile
	echo 'eval "$(rbenv init -)"' >> ~engines/.bashrc
	
	/usr/local/rbenv/plugins/ruby-build/install.sh 

  }
  
  function setup_engines_crontab {
		
	echo "Setup engines cron tab"
echo "*/10 * * * * /opt/engines/bin/engines.sh engine check_and_act all >>/opt/engines/logs/engines/restarts.log
*/10 * * * * /opt/engines/bin/engines.sh  service  check_and_act all >>/opt/engines/logs/services/restarts.log" >/tmp/ct
crontab -u engines /tmp/ct
rm /tmp/ct
}

function setup_dns {
#DHCP
 if test -f /etc/dhcp/dhclient.conf
 	then
		echo "prepend domain-name-servers 172.17.42.1;;" >> /etc/dhcp/dhclient.conf
		
		
	fi
	#temp while we wait for next dhcp renewal if using dhcp
	
echo "nameserver 172.17.42.1" >>  /etc/resolv.conf 
}
  
 function setup_ip_script {
  if ! test -f  /etc/network/if-up.d/set_ip.sh
 then 
	ln -s /opt/engines/bin/set_ip.sh /etc/network/if-up.d/
fi
  }
  
  function install_docker_and_components {
  
  create_engines_user
  update_os
  setup_startup_script
  install_docker_components
  configure_docker
  configure_engines_user
  install_rbenv
  setup_engines_crontab  	  		  
  setup_dns 	
  setup_ip_script
  }


function generate_keys {
echo "Generating system Keys"
keys=""

	for key in $keys
		do
		  ssh-keygen -q -N "" -f $key
	      cat $key.pub | awk '{ print $1 " " $2}' >$key.p
	      mv  $key.p $key.pub
	      mv $key /opt/engines/etc/keys/
	      cp $key.pub /opt/engines/system/images/03.serviceImages/$key/
	   done
	
}

function setup_mgmt_dirs {
echo "Creating Management Service Dirs"
	mkdir -p  /home/engines/db
	
	touch /home/engines/db/production.sqlite3
	touch /home/engines/db/development.sqlite3
	mkdir -p  /var/log/engines/services/mgmt
	mkdir -p /home/engines/deployment/deployed/
	mkdir -p  /var/lib/engines/mgmt/public/system/
	mkdir -p /home/engines/.ssh/mgmt/
	
	chown 21000  /home/engines/db/production.sqlite3
	chown 21000  /home/engines/db/development.sqlite3
	
	chown -R 21000 /home/engines/db/
	mkdir -p /opt/engines/run/service_manager/
	chown -R 21000 /opt/engines/run/service_manager/
	chown -R 21000 /home/engines/deployment/deployed/
	chown 21000 /var/lib/engines  /var/log/engines/containers /var/log/engines/ /var/log/engines/services/ /var/log/engines/containers/
	
	chown -R 21000 ~engines/  /var/lib/engines/mgmt/public/system/ /var/log/engines/services/mgmt 
	mkdir -p /opt/engines/run/system/flags/
	chown -R 21000 /opt/engines/run/system/
	
}

function setup_nginx_dirs {
	echo "Setup Nginx "
	mkdir -p  /var/log/engines/services/nginx/nginx
	mkdir -p /opt/engines/run/services/nginx/run/nginx/
	chown -R 22005.22005 /var/log/engines/services/nginx /opt/engines/run/services/nginx/run/nginx
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
 echo "Seting up Backup "
 mkdir -p  /var/log/engines/services/backup
 mkdir -p  /var/lib/engines/backup_paths
 chown 22015 /var/lib/engines/backup_paths/
 chown 22015 /var/log/engines/services/backup/
 mkdir -p /opt/engines/etc/backup/configs
 chown 22015 /opt/engines/etc/backup/configs
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
 echo "Setting up mongo "
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
	 }
	 
 function setup_email_dirs {
   echo "Setting up Email Dirs"
 mkdir -p /var/log/engines/services/email/apache2 /opt/engines/etc/email/ssl
 chown 22003 -R /var/log/engines/services/email/
  cp -r /var/lib/engines/cert_auth/public/certs /opt/engines/etc/email/ssl
cp -r /var/lib/engines/cert_auth/public/keys /opt/engines/etc/email/ssl
  chown 22003 -R /opt/engines/etc/email/ssl
 }
 
function make_dirs {
	
	setup_fs_dir
	setup_log_dir
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
	setup_run_dirs

mkdir -p  /var/log/engines/services/nfs/

}

function setup_mgmt_keys {

 ssh-keygen -f ~/.ssh/mgmt/restart_system -N "">>/tmp/engines_install.log
 ssh-keygen -f ~/.ssh/mgmt/update_system -N "">>/tmp/engines_install.log
 ssh-keygen -f ~/.ssh/access_system -N "">>/tmp/engines_install.log
 ssh-keygen -f ~/.ssh/mgmt/update_access_system -N "">>/tmp/engines_install.log
 ssh-keygen -f ~/.ssh/mgmt/update_engines_system_software -N "">>/tmp/engines_install.log
 ssh-keygen -f ~/.ssh/mgmt/update_engines_console_password -N "">>/tmp/engines_install.log
  
 restart_system_pub=`cat ~/.ssh/mgmt/restart_system.pub`
 update_system_pub=`cat ~/.ssh/mgmt/update_system.pub`
 update_access_system_pub=`cat ~/.ssh/mgmt/update_access_system.pub`
 update_engines_system_software=`cat ~/.ssh/mgmt/update_engines_system_software.pub`
 update_engines_console_password=`cat ~/.ssh/mgmt/update_engines_console_password.pub`
 
 echo "command=\"/opt/engines/bin/restart_system.sh\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty  $restart_system_pub " >  ~/.ssh/authorized_keys
 echo "command=\"/opt/engines/bin/update_system.sh\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty  $update_system_pub " >>  ~/.ssh/authorized_keys
 echo "command=\"/opt/engines/bin/update_system_access.sh\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty  $update_access_system_pub " >>  ~/.ssh/authorized_keys
 echo "command=\"/opt/engines/bin/update_engines_system_software.sh\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty  $update_engines_system_software " >>  ~/.ssh/authorized_keys
 echo "command=\"/opt/engines/bin/update_engines_console_password.sh\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty  $update_engines_console_password " >>  ~/.ssh/authorized_keys
}

function set_permissions {
echo "Setting directory and file permissions"
	#chown -R engines /opt/engines/ /var/lib/engines ~engines/  /var/log/engines  /var/lib/engines/mgmt/public/system/

 
	#chown  engines   /opt/engines/etc/syslog/conf/

	#chown -R 21000 /opt/engines/etc/keys

	#chown 22003 -R /opt/engines/etc/smtp
	
	#chown 22018 -R  /var/log/engines/services/nfs/
	 
	# chown  -R 22015 /opt/engines/etc/backup/

	}

function set_os_flavor {
echo "Configuring OS Specific Dockerfiles"
	if test `uname -v |grep -i ubuntu |wc -c` -gt 0
	then
		files=`find /opt/engines/system/images/ -name "*.ubuntu"`
			for file in $files
				do
					new_name=`echo $file | sed "/.ubuntu/s///"`
					rm $new_name
					mv $file $new_name
				done
	elif test `uname -v |grep -i debian  |wc -c` -gt 0
	then
		for file in $files
				do
					new_name=`echo $file | sed "/.debian/s///"`
					rm $new_name
					mv $file $new_name
				done
		else
			echo "Unsupported Linux Flavor "
			uname -v
			exit	
	fi
}

function create_services {
echo "Creating and starting Engines Services"

release=`cat /opt/engines/release`

echo "Downloading DNS image"
	docker pull engines/dns:$release >>/tmp/engines_install.log
echo "Starting DNS"
	 /opt/engines/bin/engines.rb service create dns >>/tmp/engines_install.log
 
echo "Downloading Syslog image"
	docker pull engines/syslog:$release >>/tmp/engines_install.log
echo "Starting Syslog" 
	 /opt/engines/bin/engines.rb service create syslog >>/tmp/engines_install.log
	 
echo "Downloading Cert Auth image"
	 docker pull engines/certs:$release >>/tmp/engines_install.log
echo "Starting Cert Auth"
	/opt/engines/bin/engines.rb service create cert_auth >>/tmp/engines_install.log
	
echo "Downloading  MySQL image"
	 docker pull engines/mysql:$release >>/tmp/engines_install.log
echo "Starting MySQL"	 
	 /opt/engines/bin/engines.rb service create mysql_server  >>/tmp/engines_install.log
	  
echo "Downloading Management  image"
	  docker pull engines/mgmt:$release >>/tmp/engines_install.log
echo "Starting Management"
	/opt/engines/bin/engines.rb service create mgmt >>/tmp/engines_install.log
	
echo "Downloading Auth image"
	 docker pull engines/auth:$release >>/tmp/engines_install.log 
echo "Starting Auth"
	 /opt/engines/bin/engines.rb service create auth >>/tmp/engines_install.log
	 
echo "Downloading Web Router image"
	  docker pull engines/nginx:$release >>/tmp/engines_install.log
echo "Starting Web Router"
	 /opt/engines/bin/engines.rb service create nginx >>/tmp/engines_install.log
	 
echo "Downloading Backup image"
	 docker pull engines/backup:$release >>/tmp/engines_install.log
echo "Starting Backup"
	 /opt/engines/bin/engines.rb service create backup >>/tmp/engines_install.log
	 
echo "Downloading Cron image"
	 docker pull engines/cron:$release >>/tmp/engines_install.log
 echo "Starting Cron"
	 /opt/engines/bin/engines.rb service create cron >>/tmp/engines_install.log
 	 

echo "Downloading SMTP image"
	 docker pull engines/smtp:$release >>/tmp/engines_install.log
 echo "Starting SMTP"
	 /opt/engines/bin/engines.rb service create smtp >>/tmp/engines_install.log
 	 

	  
echo "Downloading FTP image"
	docker pull engines/ftp:$release >>/tmp/engines_install.log
echo "Starting FTP"
	 /opt/engines/bin/engines.rb service create ftp >>/tmp/engines_install.log
 	
	
echo "Downloading Volmanager image"
	docker pull engines/volmanager:$release >>/tmp/engines_install.log
echo "Starting Volmanager image"
	/opt/engines/bin/engines.rb service create volmanager >>/tmp/engines_install.log

	
echo "Starting System Services"
	 /opt/engines/bin/eservices check_and_act  >>/tmp/engines_install.log &
	
}
function remove_services {
echo "Creating and starting Engines OS Services"

docker stop cAdvisor mysql_server backup nginx dns mgmt
docker rm cAdvisor mysql_server backup nginx dns mgmt
	
}

function copy_install_ssl_cert {
echo "install installation ssl cert"
#mkdir -p /opt/engines/etc/ssl/keys/
#mkdir -p /opt/engines/etc/ssl/certs/
mkdir -p /var/lib/engines/cert_auth/public/certs/ /var/lib/engines/cert_auth/public/keys/
cp ${top}/install_source/ssl/server.crt /var/lib/engines/cert_auth/public/certs/engines.crt
cp ${top}/install_source/ssl/server.key /var/lib/engines/cert_auth/public/keys/engines.key 
 mkdir  /opt/engines/etc/ca/

cp ${top}/install_source/ssl/server.crt /opt/engines/etc/ca/engines_internal_ca.crt

chown -R 22022 /var/lib/engines/cert_auth/
mkdir -p /opt/engines/etc/nginx/ssl/ /opt/engines/etc/nginx/ssl/
cp -rp /var/lib/engines/cert_auth/public/certs  /opt/engines/etc/nginx/ssl/
cp -rp /var/lib/engines/cert_auth/public/keys   /opt/engines/etc/nginx/ssl/
}
#
#function generate_ssl {
#echo "Generating Self Signed Cert"
#
#mkdir -p /opt/engines/etc/ssl/keys/
#mkdir -p /opt/engines/etc/ssl/certs/
#
#openssl genrsa -des3 -out server.key 2048
# openssl rsa -in server.key -out server.key.insecure
#  mv server.key server.key.secure
#  mv server.key.insecure server.key
#  openssl req -new -key server.key -out server.csr
#  openssl x509 -req -days 3650 -in server.csr -signkey server.key -out server.crt
#  mv server.key /opt/engines/etc/ssl/keys/engines.key
#  mv server.crt /opt/engines/etc/ssl/certs/engines.crt
#   
#   #Initial Certs for nginx are the mgmt certs
#   mkdir -p /opt/engines/etc/nginx/ssl/ /opt/engines/etc/nginx/ssl/
#   cp -rp /opt/engines/etc/ssl/certs  /opt/engines/etc/nginx/ssl/
#   cp -rp /opt/engines/etc/ssl/keys   /opt/engines/etc/nginx/ssl/
#   
#   rm server.csr  server.key.secure
#  
#}
#

