#!/usr/bin/env python3

import os

os.system("./Xilinx_Unified_2020.1_0602_1208_Lin64.bin "
          "--target /tmp/XUL --noexec")
os.chdir("/tmp/XUL")
os.system("./xsetup -b AuthTokenGen")
