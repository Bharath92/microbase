#!/bin/bash -e

cd /home/shippable/appBase

echo "================= Updating package lists ==================="
apt-get update

echo "================= Installing core binaries ==================="
add-apt-repository -y ppa:ubuntu-toolchain-r/test
echo "deb http://archive.ubuntu.com/ubuntu trusty main universe restricted multiverse" > /etc/apt/sources.list
apt-get update

apt-get install -yy g++-4.9

rm -rf /usr/local/lib/python2.7/dist-packages/requests*
pip install --upgrade pip
hash -r

echo "================== Installing python requirements ====="
pip install -r /home/shippable/appBase/requirements.txt

apt-get install -y nodejs
npm install -g forever@0.14.2 grunt grunt-cli

echo "================= Cleaning package lists ==================="
apt-get clean
apt-get autoclean
apt-get autoremove
