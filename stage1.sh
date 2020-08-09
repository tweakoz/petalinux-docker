#!/usr/bin/env sh

#install dependences:

sed -i.bak s/archive.ubuntu.com/$UBUNTU_MIRROR/g /etc/apt/sources.list
dpkg --add-architecture i386
apt-get update
apt-get install -y -q build-essential sudo vim tofrodos iproute2 gawk net-tools expect libncurses5-dev tftpd update-inetd libssl-dev flex bison
apt-get install -y -q libselinux1 gnupg wget socat gcc-multilib libidn11 libsdl1.2-dev libglib2.0-dev lib32z1-dev zlib1g:i386
apt-get install -y -q libgtk2.0-0 screen pax diffstat xvfb xterm texinfo gzip unzip cpio chrpath autoconf lsb-release
apt-get install -y -q libtool libtool-bin locales kmod git rsync bc u-boot-tools dos2unix python3-pip python-pip libyaml-dev iverilog gtkwave
apt-get install -y -q gperf help2man screen tmux x11-xserver-utils
apt-get install -y -q opencl-headers ocl-icd-opencl-dev ocl-icd-libopencl1
apt-get install -y -q libboost-dev libboost-filesystem-dev libboost-program-options-dev uuid-dev dkms libprotoc-dev protobuf-compiler libxml2-dev libudev-dev
apt-get clean
rm -rf /var/lib/apt/lists/*

locale-gen en_US.UTF-8 && update-locale

#make a user named 'eda'

adduser --disabled-password --gecos '' eda
usermod -aG sudo eda
echo "eda ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# make /bin/sh symlink to bash instead of dash:

echo "dash dash/sh boolean false" | debconf-set-selections
dpkg-reconfigure dash
