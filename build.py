#!/usr/bin/env python3
###################################
# separate docker build into separate stages for amortized build time
#  while debugging later stages
#  (stages 1, 2 and 3 can take quite a while)
###################################

import os, sys, pathlib, argparse
from ork import deco, path, command

deco = deco.Deco()
this_dir = path.Path(os.path.dirname(os.path.realpath(__file__)))

parser = argparse.ArgumentParser(description='build EDA Docker Container')

parser.add_argument('--stage1', action="store_true", help=deco.yellow('Stage1 Build (ub18.04 apt install)'))
parser.add_argument('--stage2', action="store_true", help=deco.yellow('Stage2 Build (XilinxTools install)'))
parser.add_argument('--stage3', action="store_true", help=deco.yellow('Stage3 Build (misc install)'))
parser.add_argument('--shell', action="store_true", help=deco.yellow('interactive'))
parser.add_argument('--cleanup', action="store_true", help=deco.yellow('prune intermediate images'))
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
# interactive ?
###################################

if _args["shell"]==True:
  command.system(["rm","-f","container.cid"])
  cline =  ["docker","run","-it"]
  cline += ["--net=host","--ipc=host"]
  cline += ["-v","%s:%s:ro"%(this_dir/"accept-eula.sh",
            "/tempdata/accept-eula.sh")]
  cline += ["-v","%s:%s:ro"%(this_dir/"stage2.sh",
            "/tmp/stage2.sh")]
  cline += ["-v","%s:%s:ro"%(this_dir/"stage3.sh",
            "/tmp/stage3.sh")]
  cline += ["-v","%s:%s:ro"%(inst_folder,"/inst")]
  cline += ["-w","/tmp"]
  cline += ["eda:2020.1.stage1"]
  cline += ["sudo","-u","eda",
            "/bin/bash"]
  command.system(cline)
  sys.exit(0)

###################################
# stage 2 (xilinx tools)
###################################

if _args["stage2"]==True:
  assert(inst_folder!=None)
  command.system(["rm","-f","container.cid"])
  cline =  ["docker","run","-it"]
  cline += ["--net=host","--ipc=host"]
  cline += ["-v","%s:%s:ro"%(this_dir/"accept-eula.sh",
            "/tempdata/accept-eula.sh")]
  cline += ["-v","%s:%s:ro"%(this_dir/"vitis_install_config.txt",
            "/tempdata/vitis_install_config.txt")]
  cline += ["-v","%s:%s:ro"%(inst_folder,"/inst")]
  cline += ["-v","%s:%s:ro"%(this_dir/"stage2.sh",
            "/tmp/stage2.sh")]
  cline += ["-w","/tmp"]
  cline += ["--cidfile=./container.cid"]
  cline += ["eda:2020.1.stage1"]
  cline += ["sudo","-u","eda",
            "/tmp/stage2.sh"]

  command.system(cline)
  with open('container.cid', 'r') as file:
    cid = file.read()
    command.system(["docker",
                    "commit",cid,
                    "eda:2020.1.stage2"])

###################################
# stage 3 (misc)
###################################

if _args["stage3"]==True:
  command.system(["rm","-f","container.cid"])
  cline =  ["docker","run","-it"]
  cline += ["--net=host","--ipc=host"]
  cline += ["-v","%s:%s:ro"%(this_dir/"stage3.sh",
            "/tmp/stage3.sh")]
  cline += ["-w","/tmp"]
  cline += ["--cidfile=./container.cid"]
  cline += ["eda:2020.1.stage2"]
  cline += ["sudo","-u","eda",
            "/tmp/stage3.sh"]
  command.system(cline)
  with open('container.cid', 'r') as file:
    cid = file.read()
    command.system(["docker",
                    "commit",cid,
                    "eda:2020.1.stage3"])


#if _args["cleanup"]==True:
 # command.system(["docker","image","rm","eda:2020.1.stage2"])
