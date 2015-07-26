#Installer for the Engines System

How to Use

For use on a fresh Ubuntu 14.04 or 15.x installation<br>
While Engines is in a prelease stage we do not recommend installation onto a live system.

<pre>sudo apt-get install -y git

git clone https://github.com/EnginesOS/EnginesInstaller

cd EnginesInstaller

sudo  ./install_engines.sh alpha
</pre>


The installer will take 25mins for a cloud installation, a local install will take longer dependening on the speed of your Internet connection
The total download is about 2.GB

Once finished the installer will present a url to open to configure the installation.
The user name and password combination for the initial login is admin:password

<b>Management Port</b>

If you are installing Engines remotely you will need atleast port 10443 publicly acessible to access the management interface<br>

 <b>Ports</b>
 <li>Management Interface 10443/TCP
 <li>Webpages hosted 80,443/TCP
 
 <b>Optional Ports</b>
 <li>FTP Ports 989,990/TCP
 <li>Email 25,465,993,995/TCP
 <li>DNS 53/UDP
 <li>VPN 1194/TCP+UDP
 <li>ssh to mgmt 828
 <li>ssh to host 22
 
 <strong>DNS</strong>
 On the first run wizard you will need to fill in a default domain and DNS hosting type, there are three main ways DNS can be configured.
 <br>
 <b>Private</b>
  This will setup up a DNS zone hosted on the engines server with records published with the LAN ip address.<br>
  To access the engines system set your workstations DNS server to the engines server.<br>
 <b>Public - hosted Externally</b>
  Set the default domain in the first run wizard as server_name.your.domain.name
  You will need to add the following DNS records <br>
  <pre>
   server_name.your.domain.name.	A  the_external_ip_address_of_engines_server
   *.server_name.your.domain.name.	A  the_external_ip_address_of_engines_server
  </pre>
 <br> 
 Web access to engines and services (where applicable) is then through hostname.server_name.your.domain.name
 <br>
 <b>Public - Self Hosted</b>
  Not recommended for anything other that testing purposes, engines creates and publishes the above DNS entries on the public ip address of the engines server
  <bp>
    
  
 
<h3>Other Versions</h3>
 Installer syntax<br>
sudo  ./install_enginesOS_fromScratch.sh {branch}<br>
The available branches for the EnginesSystem are
<li>alpha 
<li>master
<li>current

<p>
<li>alpha is a known good 
<li>master is the latest stable
<li>current is the bleeding edge
<li>beta comming soon -  with support for updating to future versions 
<p>
 
<h3>Support and Issues</h3>
If you have any queries and problems please email support@engines.onl or raise an issue on github

With the Installer @ https://github.com/EnginesOS/EnginesInstaller/issues/new

With the Engines System @ https://github.com/EnginesOS/System/issues/new

With the Engines Management Interface @  https://github.com/EnginesOS/SystemGui/issues/new