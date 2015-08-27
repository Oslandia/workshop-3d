#!/bin/bash -e

sudo apt-get -y install docker.io
cd
mkdir -p data/cache data/restore data/www
chmod -R 777 data
sudo docker.io run -d  -p 5432:5432 -p 80:80 -v ~/data:/data --name 3dgis_test oslandia/3dgis /sbin/my_init
