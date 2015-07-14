#!/bin/sh

docker logs -f mgmt &
pid=$!

while ! test -f /opt/engines/run/services/mgmt/run/flags/startup_complete 
 do
    sleep 5
 done
 
 kill $pid
 
 echo please visit http://extip:10443/