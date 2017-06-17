
function can_install {

if ! test `id |cut -f2 -d=|cut -f1 -d\(` -eq 0
 then
  echo "This script must be run as root or as sudo $0"
  exit 127
fi
	
if dpkg-query -W -f'${Status}' "lxc-docker" 2>/dev/null | grep -q "ok installed"; then
 	echo "Cannot install onto an existing docker host"
 	exit 127
fi

ps -ax |grep dnsmas | grep -v grep 

if test $? -eq 0
  then
  echo "Cannot Install on machine with dnsmasq enable, Please change your system "
  exit 127
fi

ps -ax |grep named | grep -v grep 

if test $? -eq 0
  then
  echo "Cannot Install on machine with bind/named enable, Please change your system "
  exit 127
fi

used_ports=`netstat -na --tcp --udp | awk ' {print $4}'  | awk -F ':' ' {print $NF}'`

for port in `cat ${top}/basic_ports_required`
 do 	
   for used_port in $used_ports
 	 do 	    	
 	  	if test $port = $used_port 
 		then
 	   	  echo error port $port taken
 	 		exit 127
 	 	fi 	
 	  done

done
}