#!/usr/bin/env bash

# Upgrade dEWDrop 5 VM to latest Node.js, NodeM and EWD.js, configure ready to run

# Build 5: 25 January 2016
#   Updated to use Node.js 4.2 and latest Nodem build
#   Also updated to use NVM v0.30
#   Thanks to David Wicksell for enhancements to upgrade script

# Upgrade Node.js

sudo apt-get purge -y nodejs
sudo apt-get autoremove -y
hash -r
rm /home/vista/mumps.node
rm -rf /home/vista/NodeM
rm -rf /home/vista/.npm
sudo rm -rf /usr/lib/node_modules
sudo rm -rf /etc/alternatives/npm
sudo rm -rf /usr/bin/npm
sudo rm -rf /var/lib/dpkg/alternatives/npm

# Install NVM and use it to install latest Node.js

sudo chattr -i ~/.profile
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.30.1/install.sh | bash
source ~/.nvm/nvm.sh
nvm install 4.2
nvm alias default 4.2

# Install gcc 4.8 for Node.js 4.2

sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get install -y gcc-5
sudo apt-get install -y g++-5
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 50
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 50

# Now ready to install EWD.js and Nodem:

cd ~
mkdir ewdjs
cd ewdjs
npm install ewdjs
npm install nodem

# Fix NodeM environment

sed -i '/# NodeM environment/,/source ${HOME}\/NodeM\/environ/d' ~/.profile
export gtmroutines=${gtmroutines/ \/home\/vista\/NodeM\/6.0-001_i686/}
cd ~

# Now ready to start EWD.js using:

# cd ~/ewdjs
# node ewdStart-gtm dewdrop-config
