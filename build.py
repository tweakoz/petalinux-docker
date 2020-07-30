#!/usr/bin/env python3

import os, sys, pathlib, argparse
from ork import deco, path, command

deco = deco.Deco()
this_dir = path.Path(os.path.dirname(os.path.realpath(__file__)))

parser = argparse.ArgumentParser(description='build EDA Docker Container')

parser.add_argument('--stage1', action="store_true", help=deco.yellow('Stage1 Build (ub18.04 apt install)'))
parser.add_argument('--stage2', action="store_true", help=deco.yellow('Stage2 Build (petalinux install)'))
parser.add_argument('--stage3', action="store_true", help=deco.yellow('Stage3 Build (vitis install)'))
parser.add_argument('--stage4', action="store_true", help=deco.yellow('Stage4 Build (misc install)'))
parser.add_argument('--instfolder', help=deco.yellow('Xilinx install files folder'))

_args = vars(parser.parse_args())

if len(sys.argv)==1:
    print(parser.format_usage())
    sys.exit(1)

os.chdir(this_dir)
###################################
inst_folder = None
if _args["instfolder"]!=None:
  inst_folder = path.Path(_args["instfolder"])
###################################
# stage 1 (base ub18.04)
###################################
if _args["stage1"]==True:
  cline =  ["docker","build"]
  cline += ["-t","eda:2020.1.stage1","."]
  command.system(cline)
###################################
# stage 2 (Petalinux)
###################################
if _args["stage2"]==True:
  assert(inst_folder!=None)
  command.system(["rm","-f","container.cid"])
  cline =  ["docker","run","-it"]
  cline += ["--net=host","--ipc=host"]
  cline += ["-v","%s:%s:ro"%(this_dir/"accept-eula.sh",
            "/tempdata/accept-eula.sh")]
  cline += ["-v","%s:%s:ro"%(inst_folder,"/inst")]
  cline += ["-w","/tmp"]
  cline += ["--cidfile=./container.cid"]
  cline += ["eda:2020.1.stage1"]
  cline += ["sudo","-u","eda",
            "-i","/tempdata/accept-eula.sh",
            "/inst/petalinux-v2020.1-final-installer.run",
            "--dir=/opt/Xilinx/petalinux-2020.1"]
  #cline += ["sudo","-u","eda",
  #          "-i","/tempdata/accept-eula.sh",
  #          "/inst/petalinux-v2019.2-final-installer.run",
  #          "/opt/Xilinx/petalinux-2019.2"]

  command.system(cline)
  with open('container.cid', 'r') as file:
    cid = file.read()
    command.system(["docker",
                    "commit",cid,
                    "eda:2020.1.stage2"])
###################################
# stage 3 (Vitis)
###################################
if _args["stage3"]==True:
  assert(inst_folder!=None)
  command.system(["rm","-f","container.cid"])
  cline =  ["docker","run","-it"]
  cline += ["--net=host","--ipc=host"]
  cline += ["-v","%s:%s:ro"%(this_dir/"vitis_install_config.txt",
            "/tempdata/vitis_install_config.txt")]
  cline += ["-v","%s:%s:ro"%(this_dir/"xilauth.key",
            "/root/.Xilinx/wi_authentication_key")]
  cline += ["-v","%s:%s:ro"%(inst_folder,"/inst")]
  cline += ["-w","/tmp"]
  cline += ["--cidfile=./container.cid"]
  cline += ["eda:2020.1.stage2"]
  cline += ["sudo",
            "/inst/Xilinx_Unified_2020.1_0602_1208/xsetup",
            "--batch", "Install",
            "--agree", "XilinxEULA,3rdPartyEULA,WebTalkTerms",
            "--location", "/opt/Xilinx/",
            "--config", "/tempdata/vitis_install_config.txt"]
  command.system(cline)
  with open('container.cid', 'r') as file:
    cid = file.read()
    command.system(["docker",
                    "commit",cid,
                    "eda:2020.1.stage3"])

###################################
# stage 4 (misc)
###################################
if _args["stage4"]==True:
  command.system(["rm","-f","container.cid"])
  cline =  ["docker","run","-it"]
  cline += ["--net=host","--ipc=host"]
  cline += ["-v","%s:%s:ro"%(this_dir/"stage4.sh",
            "/inst/stage4.sh")]
  cline += ["-w","/tmp"]
  cline += ["--cidfile=./container.cid"]
  cline += ["eda:2020.1.stage3"]
  cline += ["sudo","-u","eda",
            "/inst/stage4.sh"]
  command.system(cline)
  with open('container.cid', 'r') as file:
    cid = file.read()
    command.system(["docker",
                    "commit",cid,
                    "eda:2020.1.stage4"])
