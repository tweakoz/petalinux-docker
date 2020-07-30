#!/usr/bin/env sh

#install dependences:
cd /tmp
git clone https://github.com/Avnet/bdf
sudo cp -r /tmp/bdf/* /opt/Xilinx/Vivado/2020.1/data/boards/board_files/

#Litex
wget https://raw.githubusercontent.com/enjoy-digital/litex/master/litex_setup.py
chmod +x litex_setup.py
sudo -u eda HOME=/home/eda ./litex_setup.py init install --user

# cleanup
rm -rf /tmp/*
