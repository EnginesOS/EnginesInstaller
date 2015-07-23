#Installer for the Engines System

How to Use

For use on a fresh Ubuntu 14.04 or 15.x installation<br>
While Engines is in a prelease stage we do not recommend installation onto a live system.

<pre>sudo apt-get install -y git

git clone https://github.com/EnginesOS/EnginesInstaller

cd EnginesInstaller

sudo  ./install_enginesOS_fromScratch.sh alpha
</pre>


The installer will take 20mins for a cloud installation, a local install will take longer dependening on the speed of your Internet connection
The total download is about 2.5GB

Once finished the installer will present a url to open to configure the installation.
The user name and password combination for the initial login is admin:password

<b>Management Port</b>

If you are installing Engines remotely you will need atleast port 10443 publicly acessible to access the management interface<br>

 <b>Ports</b>
 <li>Management Interface 10443/TCP
 <li>Webpages hosted 80,443/TCP
 
 <b>Additional Optional Ports</b>
 <li>FTP Ports 989,990/TCP
 <li>Email 25,465,993,995/TCP
 <li>DNS 53/UDP
 <li>VPN 1194/TCP+UDP
 
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
 

If you have any queries and problems please email support@engines.onl or raise an issue on github

With the Installer @ https://github.com/EnginesOS/EnginesInstaller/issues/new

With the Engines System @ https://github.com/EnginesOS/System/issues/new

With the Engines Management Interface @  https://github.com/EnginesOS/SystemGui/issues/new