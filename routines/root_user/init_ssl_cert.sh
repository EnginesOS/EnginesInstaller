function copy_install_ssl_cert {
	#echo "Installing installation ssl cert"
	mkdir -p /var/lib/engines/services/cert_auth/public/certs/ /var/lib/engines/services/cert_auth/public/keys/
	chown -R 22022 /var/lib/engines//services/cert_auth/
		
}