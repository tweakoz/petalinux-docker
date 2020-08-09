#!/usr/bin/env sh


#cline += ["sudo","-u","eda",
#          "-i","/tempdata/accept-eula.sh",
#          "/inst/petalinux-v2019.2-final-installer.run",
#          "/opt/Xilinx/petalinux-2019.2"]

############################################################
# install petalinux2020
############################################################

/tempdata/accept-eula.sh \
  /inst/petalinux-v2020.1-final-installer.run \
  --dir=/opt/xilinx/petalinux-2020.1

############################################################
# install vitis
############################################################

sudo /inst/Xilinx_Unified_2020.1_0602_1208/xsetup \
  --batch Install \
  --agree XilinxEULA,3rdPartyEULA,WebTalkTerms \
  --location /opt/xilinx/ \
  --config /tempdata/vitis_install_config.txt

############################################################
# install XRT (Xilinx datacenter runtime) for development
############################################################

sudo dpkg -i /inst/xrt_202010.2.6.655_18.04-amd64-xrt.deb \
   /inst/xilinx-u50-gen3x16-xdma-dev-201920.3-2784799_18.04.deb

############################################################
