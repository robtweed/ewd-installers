#!/usr/bin/env bash

# Install and configure a GT.M-based EWD.js System from scratch

# Build 4: 25 January 2016
#   Updated to use latest Nodem LTS version
#   Also updated to use NVM v0.30.1
#     Thanks to Nitin Bhutani for amendment to code for finding latest GT.M release

# Update first just to be sure

sudo apt-get update
sudo apt-get install -y openssh-server
sudo apt-get install -y build-essential

# Install GT.M

sudo apt-get install -y fis-gtm

# Create standard default database setup

cd /usr/lib/fis-gtm
dirs=( $(find . -maxdepth 1 -type d -printf '%P\n') )
release=${dirs[`echo ${#dirs[@]} - 1`]}
cd ~

# echo -e 'H\n' | /usr/lib/fis-gtm/${dirs[0]}/gtm -direct
echo -e 'H\n' | /usr/lib/fis-gtm/$release/gtm -direct

# Install NVM (Node.js Version Manager)

sudo apt-get install -y curl
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.30.1/install.sh | bash

source ~/.nvm/nvm.sh
#nvm alias default 0.12
#nvm install 0.12

nvm alias default 4.2
nvm install 4.2
nvm use default
echo 'nvm use default' >> ~/.profile

# Now ready to install EWD.js and Nodem:

cd ~
mkdir ewdjs
cd ewdjs
npm install ewdjs

export gtm_dist=/usr/lib/fis-gtm/${dirs[0]}
npm install nodem

# Change the Nodem mumps.node to the correct one:

#cd ~/ewdjs/node_modules/nodem/lib
#rm mumps.node
#MACHINE_TYPE=`uname -m`
#if [ ${MACHINE_TYPE} == 'x86_64' ]; then
#  #mv mumps12.node_x8664 mumps.node
#  mv mumps5.1.node_x8664 mumps.node
#else
#  #mv mumps12.node_i686 mumps.node
#  mv mumps5.1.node_i686 mumps.node
#fi


# Set up symbolic link to libgtmshr so that it's available for use by NodeM

cd /usr/lib/fis-gtm
dirs=( $(find . -maxdepth 1 -type d -printf '%P\n') )
sudo ln -s /usr/lib/fis-gtm/${dirs[0]}/libgtmshr.so /usr/local/lib/libgtmshr.so
sudo ldconfig

cd ~/ewdjs


# now ready to start EWD.js using:

# cd ~/ewdjs
# node ewdStart-gtm gtm-config

