function configure_git {
	echo "Installing base Engines System"
	apt-get install -y git	>>/tmp/engines_install.log
	mkdir -p /opt/	
	git clone https://github.com/EnginesOS/System.git --branch $branch  --single-branch /opt/engines/ 	>>/tmp/engines_install.log
	echo $branch > /opt/engines/release

	updates=`ls /opt/engines/system/updates/to_run/engines/ |grep -v keep`
	cd /opt/engines/system/updates/to_run/engines/
	  for update in $updates
	   do
	     mkdir -p /opt/engines/system/updates/when_installed/engines/
	     mv $update /opt/engines/system/updates/when_installed/engines/
	   done
	updates=`ls /opt/engines/system/updates/to_run/system/ |grep -v keep`
	cd /opt/engines/system/updates/to_run/system/
	  for update in $updates
	   do
	     mkdir -p /opt/engines/system/updates/when_installed/system/
	     mv $update /opt/engines/system/updates/when_installed/system/
	   done
	mkdir -p /opt/engines/etc/ssl/ca/certs/system_CA.pem
	touch /opt/engines/etc/ssl/ca/certs/system_CA.pem

	touch /opt/engines/etc/no_obliterate 
}


function install_ruby {
   apt-get install -y ruby-dev
   gem install bundler excon multi_json rspec rubytree git net_http_unix yajl-ruby rest-client  ffi-yajl >/dev/null
}

#function install_rbenv {
#  echo "Installing rbenv"
#mkdir -p /usr/local/  
#cd /usr/local/  
# if ! test -d /usr/local/rbenv
#  then
#	git clone --depth 1 git://github.com/sstephenson/rbenv.git /usr/local/rbenv >>/tmp/engines_install.log
#
#	
#	chmod -R g+rwxXs rbenv
#	
#	cd /usr/local/rbenv   
#
#	git clone --depth 1  git://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build  >>/tmp/engines_install.log
#	
# fi
# 
# chgrp -R engines /usr/local/rbenv
# chgrp -R engines /usr/local/rbenv/plugins/ruby-build
# chmod -R g+rwxs /usr/local/rbenv/plugins/ruby-build
#	
#	grep rbenv ~/.bashrc >/dev/null
#	 if test $? -ne 0
#	  then
#		echo 'export PATH="/usr/local/rbenv/bin:$PATH"' >> ~/.bashrc 
#		echo 'eval "$(rbenv init -)"' >> ~/.bashrc 
#	 fi
#	source ~/.bashrc 
#	 
#	echo 'export PATH="/usr/local/rbenv/bin:$PATH"' >> ~engines/.profile
#	echo 'export PATH="/usr/local/rbenv/bin:$PATH"' >> ~engines/.bashrc
#	echo 'eval "$(rbenv init -)"' >> ~engines/.profile
#	echo 'eval "$(rbenv init -)"' >> ~engines/.bashrc
#	
#	/usr/local/rbenv/plugins/ruby-build/install.sh 
#	
#
#  }
  