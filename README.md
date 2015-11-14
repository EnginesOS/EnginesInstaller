#Installer for the Engines System

How to Use

For use on a fresh Ubuntu 14.04 or 15.x installation<br>
While Engines is in a prelease stage we do not recommend installation onto a live system.

<pre>sudo apt-get install -y git

git clone https://github.com/EnginesOS/EnginesInstaller

cd EnginesInstaller

sudo  ./install_engines.sh 
</pre>


The installer will take 25mins for a cloud installation, a local install will take longer dependening on the speed of your Internet connection
The total download is about 2.GB

Once finished the installer will present a url to open to configure the installation.
The user name and password combination for the initial login is admin:password<br>

<br>
<strong>System Requirements</strong><br>
2GB Ram
40 GB HD 


<h3>Configuration</h3>

 
 <h4>DNS</h4>
 On the first run wizard you will need to fill in a default domain and DNS hosting type, there are three main ways DNS can be configured.<br>
 <i>Do not use a .local suffix for the default domain. </i>
 <br>
 <br>
 <b>Private</b>
  This will setup up a DNS zone hosted on the engines server for the default domain with records published using the engines server LAN IP address.<br>
  To access the engines system you will need to set your workstations DNS server to the engines server. 
  <br>
  <br>
 <b>Public - hosted Externally</b>
  Set the default domain in the first run wizard as some.domain.name
  You will need to add the following DNS records <br>
   <pre>
   some.domain.name.	A  the_external_ip_address_of_engines_server
   *.some.domain.name.	A  the_external_ip_address_of_engines_server
  </pre>

   You may wish to set TTLs<br>
   some.domain.name. does not need to be a top level domain as in mycompany.com, but can engines.mycompany.com even engines.testing.mycompany.com as in
   <br>  
   <pre>
   engines.testing.mycompany.com.	A  the_external_ip_address_of_engines_server
   *.engines.testing.mycompany.com.	A  the_external_ip_address_of_engines_server
  </pre> 
  
 <br> 
 <br>
 Web access to engines and services (where applicable) is then through hostname.some.domain.name  in the example above mgmt.engines.testing.mycompany.com
 <br>
 <br>
 <b>Public - Self Hosted</b>
  Not recommended for anything other that testing purposes, when set engines creates and publishes the above DNS entries as an authoritive server on the public ip address of the engines server
  <p>
  You can change these latter and add additional domains through the management application and mix types.
  <br>
  <br>
  <strong>Comming soon</strong><br>
  Dynamic DNS provider support<br>
  <strong>Future</strong><br>
  Zeroconf domains<br>
   
    
  <h4>Ports</h4>

If you are installing Engines remotely you will need atleast port 10443 publicly acessible to access the management interface<br>

 <b>RequiredPorts</b>
 <li>Management Interface 10443/TCP
 <li>Webpages hosted 80,443/TCP
 
 <b>Optional Ports</b>
 <li>FTP Ports 989,990/TCP
 <li>Email 25,465,993,995/TCP
 <li>DNS 53/UDP
 <li>VPN 1194/TCP+UDP
 <li>ssh to mgmt 828
 <li>ssh to host 22
 
<h3>Other Versions</h3>
 Installer syntax<br>
sudo  ./install_engines.sh {branch}<br>
The available branches for the EnginesSystem are
<li>beta-rc (default)
<li>master
<li>current

<p>
<li>beta-rc with support for updating to future versions hopefully all the way up to beta-release and beyond  
<li>master is the latest stable
<li>current is the bleeding edge
<li>
<p>
 
<h3>Support and Issues</h3>
If you have any queries and problems please email support@engines.onl or raise an issue on github

With the Installer @ https://github.com/EnginesOS/EnginesInstaller/issues/new

With the Engines System @ https://github.com/EnginesOS/System/issues/new

With the Engines Management Interface @  https://github.com/EnginesOS/SystemGui/issues/new