#!/usr/bin/env sh

#install dependences:
cd /tmp
git clone https://github.com/Avnet/bdf
sudo cp -r /tmp/bdf/* /opt/xilinx/Vivado/2020.1/data/boards/board_files/

#Litex
wget https://raw.githubusercontent.com/enjoy-digital/litex/master/litex_setup.py
chmod +x litex_setup.py
sudo -u eda HOME=/home/eda ./litex_setup.py init install --user

#Nmigen
pip3 install nmigen


#XilinxBoardStore
cd /tmp
git clone https://github.com/tweakoz/XilinxBoardStore
sudo cp -r XilinxBoardStore/boards/Xilinx/au* /opt/xilinx/Vivado/2020.1/data/boards/board_files/
sudo cp -r XilinxBoardStore/boards/Digilent/arty-a7-35 /opt/xilinx/Vivado/2020.1/data/boards/board_files/
sudo cp -r XilinxBoardStore/boards/Digilent/cmod_a7-35t /opt/xilinx/Vivado/2020.1/data/boards/board_files/
sudo cp -r XilinxBoardStore/boards/Digilent/nexys4 /opt/xilinx/Vivado/2020.1/data/boards/board_files/
sudo cp -r XilinxBoardStore/boards/Digilent/nexys_video /opt/xilinx/Vivado/2020.1/data/boards/board_files/
sudo cp -r XilinxBoardStore/boards/Digilent/zedboard /opt/xilinx/Vivado/2020.1/data/boards/board_files/

#yosys
git clone https://github.com/cliffordwolf/yosys.git
cd yosys
git checkout 9a4f420b4b8285bd05181b6988c35ce45e3c979a
make -j 8
sudo make install

#icestorm
git clone https://github.com/YosysHQ/icestorm
cd icestorm
git checkout d12308775684cf43ab923227235b4ad43060015e
make -j 8
sudo make install

git clone https://github.com/YosysHQ/SymbiYosys
cd SymbiYosys
#git checkout d12308775684cf43ab923227235b4ad43060015e
sudo make install
make test

# cleanup
rm -rf /tmp/*

cd /home/eda/
git clone https://github.com/tweakoz/Vitis-In-Depth-Tutorial
git clone https://github.com/tweakoz/ultrazed_ev_cc_hello_pl
git clone https://github.com/cliffordwolf/SimpleVOut
git clone https://github.com/ucb-bar/chisel-tutorial
git clone https://github.com/SpinalHDL/SpinalTemplateSbt

#SpinalHDL
cd /home/eda/SpinalTemplateSbt
sbt run   # select "mylib.MyTopLevelVhdl" in the menu
ls MyTopLevel.vhd

#SpinalHDL
cd /home/eda/chisel-tutorial/hello
make
