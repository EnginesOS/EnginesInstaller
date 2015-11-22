
function create_services {
echo "Creating and starting Engines Services"

release=`cat /opt/engines/release`
echo "Downloading Registry image"
	docker pull engines/registry:$release >>/tmp/engines_install.log
	/opt/engines/bin/engines.rb service stop dns  >>/tmp/engines_install.log
echo "Starting DNS"
echo "Downloading DNS image"
	docker pull engines/dns:$release >>/tmp/engines_install.log
echo "Starting DNS"
	 /opt/engines/bin/engines.rb service create dns >>/tmp/engines_install.log

echo "Downloading Syslog image"
	docker pull engines/syslog:$release >>/tmp/engines_install.log
echo "Starting Syslog" 
	 /opt/engines/bin/engines.rb service create syslog >>/tmp/engines_install.log
	 echo "Downloading Avahi 
	docker pull engines/avahi:$release >>/tmp/engines_install.log
echo "Starting Avahi"
	  /opt/engines/bin/engines.rb service create avahi >>/tmp/engines_install.log
	  
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