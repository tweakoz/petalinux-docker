#!/usr/bin/env python3

import os, platform

DISPLAY=os.environ["DISPLAY"]

osname = platform.system()

if osname=="Darwin": 
 os.system("xhost + 127.0.0.1") 
 DISPLAY="host.docker.internal:0"


os.system('docker run -ti --rm -e DISPLAY=%s '
          '--net=host --ipc=host -v /tmp/.X11-unix:/tmp/.X11-unix '
          '-v $HOME/.Xauthority:/home/vivado/.Xauthority '
          '-v $HOME/Xilinx:/home/vivado/project '
          'petalinux:2020.1 '
          '/bin/bash' % DISPLAY )
