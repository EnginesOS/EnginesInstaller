function copy_install_ssl_cert {
	#echo "Installing installation ssl cert"
	mkdir -p /var/lib/engines/services/certs/public/certs/ /var/lib/engines/services/certs/public/keys/
	chown -R 22022 /var/lib/engines//services/certs/
		
}