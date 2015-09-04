#!/bin/bash -e

cd
mkdir -p data/cache data/restore data/www
chmod -R 777 data
sudo docker run -d  -p 5432:5432 -p 80:80 -v ~/data:/data --name 3dgis_test oslandia/3dgish /sbin/my_init
ln -s /vagrant/run3dgis.sh ~/run3dgis.sh
