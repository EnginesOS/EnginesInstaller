#Install for the Engines System

How to Use

On a fresh Ubuntu 14.04 or 15 installation

sudo apt-get install -y git

git clone https://github.com/EnginesOS/EnginesInstaller

cd EnginesInstaller

sudo  ./install_enginesOS_fromScratch.sh {branch}

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

If you are installing Engines remotely you will need atleast port 10443 pubically acessible to access the the management interface
 

