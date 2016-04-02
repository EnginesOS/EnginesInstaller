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

 function update_os {
   echo "Updating OS to Latest"
   apt-get -y update >>/tmp/engines_install.log
env DEBIAN_FRONTEND=noninteractive   apt-get -q -y -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade >>/tmp/engines_install.log
#DEBIAN_PRIORITY=critical
apt-get install -y apt-transport-https    linux-image-extra-$(uname -r) lvm2 thin-provisioning-tools >>/tmp/engines_install.log

   

  }
  
    
  function setup_startup_script {
  echo "Adding startup script"
   cat /etc/rc.local | sed "/^exit.*$/s//su  engines \/opt\/engines\/bin\/engines_startup.sh" > /tmp/rc.local	
		
		 echo "exit 0"  >> /tmp/rc.local
		 cp /tmp/rc.local /etc/rc.local
		 rm  /tmp/rc.local		
		 chmod u+x  /etc/rc.local
  }