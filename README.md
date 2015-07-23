#Installer for the Engines System

How to Use

On a fresh Ubuntu 14.04 or 15 installation

<pre>sudo apt-get install -y git

git clone https://github.com/EnginesOS/EnginesInstaller

cd EnginesInstaller

sudo  ./install_enginesOS_fromScratch.sh {branch}
</pre>
The available branches for the EnginesSystem are
<li>alpha 
<li>master
<li>current

<li>alpha is a known good
<li>master is the latest stable
<li>current is the bleeding edge
<li>beta comming soon -  with support for updating to future versions 

The installer will take 20mins for a cloud installation, a local install will take longer dependening on the speed of your Internet connection
The total download is about 2.5GB

Once finished the installer will present the url to open to complete the installation.

<b>Management Port</b>

If you are installing Engines remotely you will need atleast port 10443 publicaly acessible to access the management interface<br>

 <b>Ports</b>
 <li>Management Interface 10443/TCP
 <li>Webpages hosted 80,443/TCP
 
 <b>Additional Optional Ports</b>
 <li>FTP Ports xx,xx,xx,xx/TCP
 <li>Email 25,465,xx,xx,xx/TCP
 <li>DNS 53/UDP
 <li>VPN xxx/TCP xxx/UDP
 

If you have any queries and problems please email support@engines.onl or raise an issue on github

With the Installer @ https://github.com/EnginesOS/EnginesInstaller/issues/new

With the Engines System @ https://github.com/EnginesOS/System/issues/new

With the Engines Management Interface @  https://github.com/EnginesOS/SystemGui/issues/new