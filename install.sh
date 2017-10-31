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

wget https://nodejs.org/dist/v4.8.5/node-v4.8.5-linux-x64.tar.xz
tar -xvf node-v4.8.5-linux-x64.tar.xz
cp -Rvf node-v4.8.5-linux-x64/{bin,include,lib,share} /usr/local
npm install -g forever@0.14.2 grunt grunt-cli

echo "================= Cleaning package lists ==================="
apt-get purge libapparmor1
apt-get clean
apt-get autoclean
apt-get autoremove
