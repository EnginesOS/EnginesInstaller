#!/bin/bash
RUBY_VER=2.2.2
#*******************************************************************************
# Copyright (c) 2015 P3Nominees.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
#*******************************************************************************




function set_permissions {
echo "Setting directory and file permissions"
	
touch /opt/engines/etc/os-release-host
chown  21000 /opt/engines/etc/os-release-host
	}




function remove_services {
echo "Creating and starting Engines OS Services"

docker stop  mysqld backup wap dns control
docker rm  mysqld backup wap dns control
	
}


