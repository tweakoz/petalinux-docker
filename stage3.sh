#!/usr/bin/env sh

#install dependences:
cd /tmp
git clone https://github.com/Avnet/bdf
sudo cp -r /tmp/bdf/* /opt/xilinx/Vivado/2020.1/data/boards/board_files/

#Litex
wget https://raw.githubusercontent.com/enjoy-digital/litex/master/litex_setup.py
chmod +x litex_setup.py
sudo -u eda HOME=/home/eda ./litex_setup.py init install --user

#XilinxBoardStore
cd /tmp
git clone https://github.com/tweakoz/XilinxBoardStore
sudo cp -r XilinxBoardStore/boards/Xilinx/au* /opt/xilinx/Vivado/2020.1/data/boards/board_files/
sudo cp -r XilinxBoardStore/boards/Digilent/arty-a7-35 /opt/xilinx/Vivado/2020.1/data/boards/board_files/
sudo cp -r XilinxBoardStore/boards/Digilent/cmod_a7-35t /opt/xilinx/Vivado/2020.1/data/boards/board_files/
sudo cp -r XilinxBoardStore/boards/Digilent/nexys4 /opt/xilinx/Vivado/2020.1/data/boards/board_files/
sudo cp -r XilinxBoardStore/boards/Digilent/nexys_video /opt/xilinx/Vivado/2020.1/data/boards/board_files/
sudo cp -r XilinxBoardStore/boards/Digilent/zedboard /opt/xilinx/Vivado/2020.1/data/boards/board_files/

# cleanup
rm -rf /tmp/*

cd /home/eda/
git clone https://github.com/tweakoz/Vitis-In-Depth-Tutorial
git clone https://github.com/tweakoz/ultrazed_ev_cc_hello_pl
