#!/usr/bin/env bash

# Prepare Ubuntu system ready for EWD.js and Cache
#   Assumes you've put the Cache installation file into home directory ~

# Subsequent installation logic will assume you install Cache into /opt/cache
#  adjust accordingly if you've installed it elsewhere

# Update first just to be sure

sudo apt-get update
sudo apt-get install -y wget gzip openssh-server curl

# First increase shared memory quotas for Cache

sudo sysctl -w kernel.shmall=536870912
sudo sysctl -w kernel.shmmax=536870912
sudo /bin/su -c "echo 'kernel.shmall=536870912' >> /etc/sysctl.conf"
sudo /bin/su -c "echo 'kernel.shmmax=536870912' >> /etc/sysctl.conf"

# Install Cache from installation tar.gz file

mkdir /tmp/cachekit
cd ~
gunzip -c cache*.tar.gz | ( cd /tmp/cachekit ; tar xf - )
cd /tmp/cachekit
sudo ./cinstall

# Note: when asked for responses:
#   Accept 1 - Suse Linux
#   Accept instance name of CACHE
#   Installation directory assumed to be /opt/cache
#   Accept 1 - Development server
#   Say yes to Unicode
#   Accept Minimal Security settings (1)
#   If using EC2, group to use is ubuntu
#   Accept No to license - install your own later into /opt/cache/mgr
#   Then accept settings

# Install NVM and use it to install Node.js 0.10
#  Note Cache does not yet support Node.js 0.12

curl https://raw.githubusercontent.com/creationix/nvm/v0.25.4/install.sh | sh
source ~/.nvm/nvm.sh
nvm alias default 0.10
nvm install 0.10
nvm use default
echo 'nvm use default' >> ~/.profile

# Allow nvm-controlled node command to be called from sudo

n=$(which node);n=${n%/bin/node}; chmod -R 755 $n/bin/*; sudo cp -r $n/{bin,lib,share} /usr/local

# Now ready to install EWD.js:

cd ~
mkdir ewdjs
cd ewdjs
npm install ewdjs

# Move the Node.js interface file into the correct place
#  Assumes that Cache was installedd into /opt/cache
#  Modify path as appropriate

sudo mv /opt/cache/bin/cache0100.node ~/ewdjs/node_modules/cache.node

cd ~/ewdjs

# Make sure you install a Cache license, stop and restart Cache

# To stop Cache afer you've added your license:

#   ccontrol stop CACHE

# To restart:

#   ccontrol start CACHE

# now ready to start EWD.js using:

# review the ~/ewdjs/ewdStart-cache.linux.js file and ensure the settings are OK, then:

# cd ~/ewdjs
# sudo node ewdStart-cache-linux






 