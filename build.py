#!/usr/bin/env python3

import os, pathlib, argparse

os.system("docker build "
          "--build-arg PETA_VERSION=2019.2 "
          "--build-arg PETA_RUN_FILE=petalinux-v2019.2-final-installer.run "
          "--build-arg VIVADO_RUN_FILE=Xilinx_Unified_2020.1_0602_1208_Lin64.bin "
          "--build-arg XILAUTHKEY=xilauth.key "
          "-t petalinux:2020.1 .")
