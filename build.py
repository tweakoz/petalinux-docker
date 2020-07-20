#!/usr/bin/env python3

import os

os.system("docker build "
          "--build-arg PETA_VERSION=2020.1 "
          "--build-arg PETA_RUN_FILE=petalinux-v2020.1-final-installer.run "
          "-t petalinux:2020.1 .")
