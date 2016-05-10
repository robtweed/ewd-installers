#!/usr/bin/env bash

# run using: source install_cache.sh

# Prepare

sudo apt-get update
sudo apt-get install -y build-essential
sudo apt-get install -y wget gzip openssh-server curl

# Cache

sudo sysctl -w kernel.shmall=536870912
sudo sysctl -w kernel.shmmax=536870912
sudo /bin/su -c "echo 'kernel.shmall=536870912' >> /etc/sysctl.conf"
sudo /bin/su -c "echo 'kernel.shmmax=536870912' >> /etc/sysctl.conf"

# At this point, it's assumed that you've downloaded and saved a copy of
# a Cache installation file from InterSystems, eg cache-2015.2.tar.gz
#  If you're using Ubuntu, get the build for Suse Linux
#   ... now install it:

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


# Cache key

cd /opt/cache/mgr

#  !! At this point you copy your cache.key into this directory
#  and then restart Cache: 

ccontrol stop cache restart quietly

# Node.js

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
source ~/.nvm/nvm.sh

#  I'm going to install the latest LTS version of Node.js: 4.4, but any earlier version will do

nvm alias default 4.4
nvm install 4.4
nvm use default
echo 'nvm use default' >> ~/.profile

sudo ln -s /usr/local/bin/node /usr/bin/node
sudo ln -s /usr/local/lib/node /usr/lib/node
sudo ln -s /usr/local/bin/npm /usr/bin/npm
sudo ln -s /usr/local/bin/node-waf /usr/bin/node-waf
n=$(which node);n=${n%/bin/node}; chmod -R 755 $n/bin/*; sudo cp -r $n/{bin,lib,share} /usr/local

# Now install ewd-xpress and its peer dependencies
# First create a parent directory for all your EWD 3 work, eg ~/ewd3

cd ~
mkdir ewd3
cd ewd3

npm install ewd-xpress ewd-xpress-monitor

# Note: ewd-express will install all its peer dependencies.  Ignore the warnings from NPM!

# cache.node

cd ~/ewd3/node_modules

# You'll need a compatible copy of the cache.node interface file, ie cache421.node:
#  rename it to cache.node:

mv cache421.node cache.node

# Finally move various files into place:

mv ~/ewd3/node_modules/ewd-xpress/example/ewd-xpress.js ~/ewd3/ewd-xpress.js

cd ~/ewd3
mkdir www
cd www
mkdir ewd-xpress-monitor
cp ~/ewd3/node_modules/ewd-xpress-monitor/www/bundle.js ~/ewd3/www/ewd-xpress-monitor
cp ~/ewd3/node_modules/ewd-xpress-monitor/www/*.html ~/ewd3/www/ewd-xpress-monitor
cp ~/ewd3/node_modules/ewd-xpress-monitor/www/*.css ~/ewd3/www/ewd-xpress-monitor

cd ~/ewd3

echo 'Done!'
