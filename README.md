# petalinux-vivado-docker

Petalinux+Vivado (2020.1) Docker container with X11 support
 Derives from Stock Ubuntu 18.04 (from ubuntu's Dockerhub)

1. Copy petalinux-2020.1-final-installer.run to this folder.
2. Copy Xilinx_Unified_2020.1_0602_1208_Lin64.bin to this folder.
3. generate xilinx auth token (see genauthtoken.py)
4. build docker image: `./build.py`
5. launch bash in docker image: `./launch.py`

* TODO:
  query xilinx password and login from user before docker build.
  generate wi_authentication_key `./xsetup -b AuthTokenGen`
  pass in generated wi_authentication_key
