#!/bin/bash
sudo docker stop 3dgis_test
sudo docker rm 3dgis_test
sudo docker run --rm -p 5432:5432 -p 80:80 -v /home/vagrant/data:/data --name 3dgis_test oslandia/3dgish /sbin/my_init
