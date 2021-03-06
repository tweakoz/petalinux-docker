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
chmod a+rx /$PETA_RUN_FILE
chmod a+rx /accept-eula.sh
chmod a+r /vivado_install_config.txt
dos2unix /accept-eula.sh
dos2unix /vivado_install_config.txt
cd /tmp
sudo -u vivado -i /accept-eula.sh /$PETA_RUN_FILE --dir=/opt/Xilinx/petalinux

# run the vivado install
cd /tmp
/$VIVADO_RUN_FILE --target /tmp/XUL --noexec
/tmp/XUL/xsetup --batch Install --agree XilinxEULA,3rdPartyEULA,WebTalkTerms --location /opt/Xilinx/ --config /vivado_install_config.txt

# Avnet board files
cd /tmp
git clone https://github.com/Avnet/bdf
cp -r /tmp/bdf/* /opt/Xilinx/Vivado/2020.1/data/boards/board_files/

#Litex
wget https://raw.githubusercontent.com/enjoy-digital/litex/master/litex_setup.py
chmod +x litex_setup.py
sudo -u vivado HOME=/home/vivado ./litex_setup.py init install --user

# cleanup
rm -f /$VIVADO_RUN_FILE
rm -f /vivado_install_config.txt
rm -rf /tmp/XUL
rm -f /$PETA_RUN_FILE
rm -f /accept-eula.sh

# make /bin/sh symlink to bash instead of dash:
echo "dash dash/sh boolean false" | debconf-set-selections
dpkg-reconfigure dash
