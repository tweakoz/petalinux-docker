# petalinux-docker

Copy petalinux-v2019.2-final-installer.run file to this folder. Then run

`docker build --build-arg PETA_VERSION=2019.2 --build-arg PETA_RUN_FILE=petalinux-v2019.2-final-installer.run -t petalinux:2019.2 .`

After installation, launch petalinux on a linux host with:

`docker run -ti --rm -e DISPLAY=$DISPLAY --net="host" -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/.Xauthority:/home/vivado/.Xauthority -v $HOME/Projects:/home/vivado/project  petalinux:2019.2 /bin/bash`
