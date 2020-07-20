FROM ubuntu:18.04

MAINTAINER tweakoz <tweakoz@users.noreply.github.com>

# build with docker build --build-arg PETA_VERSION=2020.1 --build-arg PETA_RUN_FILE=petalinux-v2020.1-final-installer.run -t petalinux:2020.1 .

ARG UBUNTU_MIRROR=archive.ubuntu.com
ARG PETA_VERSION
ARG PETA_RUN_FILE
ARG VIVADO_RUN_FILE
ARG XILAUTHKEY

ENV DEBIAN_FRONTEND=noninteractive

#install dependences:
RUN sed -i.bak s/archive.ubuntu.com/${UBUNTU_MIRROR}/g /etc/apt/sources.list
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y -q build-essential sudo vim tofrodos iproute2 gawk net-tools expect libncurses5-dev tftpd update-inetd libssl-dev flex bison
RUN apt-get install -y -q libselinux1 gnupg wget socat gcc-multilib libidn11 libsdl1.2-dev libglib2.0-dev lib32z1-dev zlib1g:i386
RUN apt-get install -y -q libgtk2.0-0 screen pax diffstat xvfb xterm texinfo gzip unzip cpio chrpath autoconf lsb-release
RUN apt-get install -y -q libtool libtool-bin locales kmod git rsync bc u-boot-tools dos2unix python3-pip python-pip
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8 && update-locale

#make a Vivado user
RUN adduser --disabled-password --gecos '' vivado
RUN usermod -aG sudo vivado
RUN echo "vivado ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY accept-eula.sh ${PETA_RUN_FILE} ${VIVADO_RUN_FILE} ${XILAUTHKEY} vivado_install_config.txt /
# run the petalinux install
RUN chmod a+rx /${PETA_RUN_FILE}
RUN chmod a+rx /accept-eula.sh
RUN chmod a+r /vivado_install_config.txt
RUN dos2unix /accept-eula.sh
RUN dos2unix /vivado_install_config.txt
RUN mkdir -p /opt/Xilinx
RUN chmod 777 /tmp /opt/Xilinx
RUN cd /tmp
RUN sudo -u vivado -i /accept-eula.sh /${PETA_RUN_FILE} --dir=/opt/Xilinx/petalinux
RUN rm -f /${PETA_RUN_FILE} /accept-eula.sh

# run the vivado install
RUN mkdir /root/.Xilinx
COPY ${XILAUTHKEY} /root/.Xilinx/wi_authentication_key
RUN /${VIVADO_RUN_FILE} --target /tmp/XUL --noexec
RUN /tmp/XUL/xsetup --batch Install --agree XilinxEULA,3rdPartyEULA,WebTalkTerms --location /opt/Xilinx/ --config /vivado_install_config.txt
RUN rm -f /${VIVADO_RUN_FILE} /vivado_install_config.txt

# make /bin/sh symlink to bash instead of dash:
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

USER vivado
ENV HOME /home/vivado
ENV LANG en_US.UTF-8
RUN mkdir /home/vivado/project
WORKDIR /home/vivado/project

#add vivado tools to path
RUN echo "source /opt/Xilinx/petalinux/settings.sh" >> /home/vivado/.bashrc
