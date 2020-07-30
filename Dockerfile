FROM ubuntu:18.04

MAINTAINER tweakoz <tweakoz@users.noreply.github.com>

ARG UBUNTU_MIRROR=archive.ubuntu.com
#ARG PETA_VERSION
#ARG PETA_RUN_FILE
#ARG VIVADO_RUN_FILE
#ARG XILAUTHKEY

ENV DEBIAN_FRONTEND=noninteractive
ENV UBUNTU_MIRROR=${UBUNTU_MIRROR}
#ENV PETA_VERSION=${PETA_VERSION}
#ENV PETA_RUN_FILE=${PETA_RUN_FILE}
#ENV VIVADO_RUN_FILE=${VIVADO_RUN_FILE}
#ENV XILAUTHKEY=${XILAUTHKEY}

RUN mkdir /root/.Xilinx
RUN mkdir -p /opt/Xilinx

COPY stage1.sh /
#COPY accept-eula.sh /
###################################
# todo: investigate
#  other method of getting
#  petalinux and vivado installers
#  onto the container
#  to reduce final image download
#  footprint by around 1.5GiB.
#  eg scp, direct download (from container), etc...
###################################
#COPY ${PETA_RUN_FILE} /
#COPY ${VIVADO_RUN_FILE} /
#COPY ${XILAUTHKEY} /
#COPY vitis_install_config.txt /
#COPY ${XILAUTHKEY} /root/.Xilinx/wi_authentication_key

RUN chmod 777 /tmp /opt/Xilinx /stage1.sh

###################################
# invoke stage1
###################################
#  we call a script because:
#  1. we want to reduce image size
#  2. looking at a bunch of &&'ed commands
#      reduces the code's signal to noise ratio
#     I would dare say docker's Dockerfile language
#     must be lacking expressiveness since reducing
#     image size requires mashing a bunch of commands
#     together with && thereby reducing readability.
#  3. todo: balance build time with image size.. argh..
###################################

RUN /stage1.sh
RUN rm /stage1.sh

###################################

USER eda
ENV HOME /home/eda
ENV LANG en_US.UTF-8
ENV PATH="$PATH:~/.local/bin"
RUN mkdir /home/eda/project
WORKDIR /home/eda/project

#add vivado tools to path
RUN echo "source /opt/Xilinx/petalinux-2020.1/settings.sh" >> /home/eda/.bashrc
RUN echo "source /opt/Xilinx/Vivado/2020.1/settings64.sh" >> /home/eda/.bashrc
RUN echo "source /opt/Xilinx/Vitis/2020.1/settings64.sh" >> /home/eda/.bashrc

# enable bashrc in non-interactive bash commands
RUN sed -i.bak '6,9d' /home/eda/.bashrc
