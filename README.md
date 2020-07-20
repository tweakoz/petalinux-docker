# petalinux-docker

1. generate xilinx auth token (see genauthtoken.py)
2. Copy petalinux-2020.1-final-installer.run file to this folder. 2. build docker image: `./build.py`
3. launch bash in docker image: `./launch.py`

* TODO:
  query xilinx password and login from user before docker build.
  generate wi_authentication_key `./xsetup -b AuthTokenGen`
  pass in generated wi_authentication_key
