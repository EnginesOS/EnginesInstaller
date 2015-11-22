function copy_install_ssl_cert {
echo "Installing installation ssl cert"

mkdir -p /var/lib/engines/cert_auth/public/certs/ /var/lib/engines/cert_auth/public/keys/
cp ${top}/install_source/ssl/server.crt /var/lib/engines/cert_auth/public/certs/engines.crt
cp ${top}/install_source/ssl/server.key /var/lib/engines/cert_auth/public/keys/engines.key 
 mkdir  /opt/engines/etc/ca/

cp ${top}/install_source/ssl/server.crt /opt/engines/etc/ca/engines_internal_ca.crt

chown -R 22022 /var/lib/engines/cert_auth/
mkdir -p /opt/engines/etc/nginx/ssl/ /opt/engines/etc/nginx/ssl/
cp -rp /var/lib/engines/cert_auth/public/certs  /opt/engines/etc/nginx/ssl/
cp -rp /var/lib/engines/cert_auth/public/keys   /opt/engines/etc/nginx/ssl/
}