function configure_git {
	echo "Installing base Engines System"
	apt-get install -y git	>>/tmp/engines_install.log
	mkdir -p /opt/	
	git clone https://github.com/EnginesOS/System.git --branch $branch  --single-branch /opt/engines/ 	>>/tmp/engines_install.log
	echo $branch > /opt/engines/release

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
  