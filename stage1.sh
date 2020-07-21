#!/usr/bin/env sh

#install dependences:

sed -i.bak s/archive.ubuntu.com/$UBUNTU_MIRROR/g /etc/apt/sources.list
dpkg --add-architecture i386
apt-get update
apt-get install -y -q build-essential sudo vim tofrodos iproute2 gawk net-tools expect libncurses5-dev tftpd update-inetd libssl-dev flex bison
apt-get install -y -q libselinux1 gnupg wget socat gcc-multilib libidn11 libsdl1.2-dev libglib2.0-dev lib32z1-dev zlib1g:i386
apt-get install -y -q libgtk2.0-0 screen pax diffstat xvfb xterm texinfo gzip unzip cpio chrpath autoconf lsb-release
apt-get install -y -q libtool libtool-bin locales kmod git rsync bc u-boot-tools dos2unix python3-pip python-pip
apt-get clean
rm -rf /var/lib/apt/lists/*

locale-gen en_US.UTF-8 && update-locale

#make a Vivado user
adduser --disabled-password --gecos '' vivado
usermod -aG sudo vivado
echo "vivado ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# run the petalinux install
chmod a+rx /${PETA_RUN_FILE}
chmod a+rx /accept-eula.sh
chmod a+r /vivado_install_config.txt
dos2unix /accept-eula.sh
dos2unix /vivado_install_config.txt
cd /tmp
sudo -u vivado -i /accept-eula.sh /${PETA_RUN_FILE} --dir=/opt/Xilinx/petalinux
rm -f /${PETA_RUN_FILE} /accept-eula.sh

# run the vivado install
/${VIVADO_RUN_FILE} --target /tmp/XUL --noexec
/tmp/XUL/xsetup --batch Install --agree XilinxEULA,3rdPartyEULA,WebTalkTerms --location /opt/Xilinx/ --config /vivado_install_config.txt
rm -f /${VIVADO_RUN_FILE} /vivado_install_config.txt

# make /bin/sh symlink to bash instead of dash:
echo "dash dash/sh boolean false" | debconf-set-selections
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash
