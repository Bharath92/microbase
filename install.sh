#!/bin/bash -e

dpkg-divert --local --rename --add /sbin/initctl
locale-gen en_US en_US.UTF-8
dpkg-reconfigure locales

cd /home/shippable/appBase

echo "================== Adding empty known hosts file =============="
mkdir -p /root/.ssh
touch /root/.ssh/known_hosts

echo "================== Disabling scrict host checking for ssh ====="
mv config /root/.ssh/config
mv 90forceyes /etc/apt/apt.conf.d/
echo 'ALL ALL=(ALL) NOPASSWD:ALL' | tee -a /etc/sudoers

echo "================= Updating package lists ==================="
apt-get update

echo "================= Installing core binaries ==================="
apt-get install -yy python-dev software-properties-common python-software-properties;
add-apt-repository -y ppa:ubuntu-toolchain-r/test
echo "deb http://archive.ubuntu.com/ubuntu trusty main universe restricted multiverse" > /etc/apt/sources.list
apt-get update

apt-get install -yy build-essential \
                    g++-4.9 \
                    wget \
                    curl \
                    texinfo \
                    make \
                    openssh-client \
                    sudo \
                    unzip \
                    htop;

echo "================= Installing Git ==================="
add-apt-repository ppa:git-core/ppa -y
apt-get update
apt-get install -y git

echo "================= Installing Python packages ==================="
apt-get install -y \
  python-pip \
  python-software-properties \
  python-dev

rm -rf /usr/local/lib/python2.7/dist-packages/requests*
pip install --upgrade pip
hash -r
pip install virtualenv

echo "================== Installing python requirements ====="
pip install -r /home/shippable/appBase/requirements.txt

echo "================= Installing Node ==================="
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
apt-get update

apt-get install -y nodejs
npm install -g forever@0.14.2 grunt grunt-cli

echo "================= Adding gcloud 128.0.0 ============"
CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update && sudo apt-get install google-cloud-sdk

echo "================= Adding awscli 1.11.35 ============"
sudo pip install 'awscli==1.11.35'

echo "================= Adding awsebcli 3.7.8 ============"
sudo pip install 'awsebcli==3.7.8'

echo "================= Adding jfrog-cli 1.4.1 ==================="
wget -v https://api.bintray.com/content/jfrog/jfrog-cli-go/1.4.1/jfrog-cli-linux-amd64/jfrog?bt_package=jfrog-cli-linux-amd64 -O jfrog
sudo chmod +x jfrog
mv jfrog /usr/bin/jfrog

echo "================= Adding kubectl 1.5.1 ==================="
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.5.1/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

echo "================= Adding terraform ==================="
curl -LO https://releases.hashicorp.com/terraform/0.8.5/terraform_0.8.5_linux_amd64.zip
unzip terraform_0.8.5_linux_amd64.zip -d /usr/local/bin/terraform
echo 'export PATH=$PATH:/usr/local/bin/terraform' >> /root/.bashrc

echo "================= Adding utilities ==================="
apt-get install -y gettext \
                   jq

echo "================= Cleaning package lists ==================="
apt-get clean
apt-get autoclean
apt-get autoremove
