
function setup_dns {
 echo "Applying DNS Settings"


resolv_file=/etc/resolv.conf

	#temp while we wait for next dhcp renewal if using dhcp
	# dotn write to head if dhcp as we use hook in dhcp to add dynamic ip
	if ! test -d /etc/dhcp/dhclient-enter-hooks.d
	then
	  if test -f etc/resolvconf/resolv.conf.d/
	    then
			echo "nameserver $ip" >> /etc/resolvconf/resolv.conf.d/head
	  fi
	fi
ip=`/opt/engines/bin/system_ip.sh`
echo "nameserver $ip" >> $resolv_file  

if test -d   /etc/dhcp/dhclient-enter-hooks.d/
	then
		cp ${top}/install_source/etc/dhcp/dhclient-enter-hooks.d/engines /etc/dhcp/dhclient-enter-hooks.d/
		echo "DHCP DNS server hook installed"
	fi


}
  
 function setup_ip_script {
 echo "Installing ip-up hook"
  if ! test -f  /etc/network/if-up.d/set_ip.sh
 then 
	ln -s /opt/engines/system scripts/dhcpd/set_ip.sh /etc/network/if-up.d/
fi
  }