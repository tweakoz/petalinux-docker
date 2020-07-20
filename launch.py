#!/usr/bin/env python3

import os

os.system('docker run -ti --rm -e DISPLAY=$DISPLAY '
          '--net="host" -v /tmp/.X11-unix:/tmp/.X11-unix '
          '-v $HOME/.Xauthority:/home/vivado/.Xauthority '
          '-v $HOME/Xilinx:/home/vivado/project '
          'petalinux:2020.1 '
          '/bin/bash')
