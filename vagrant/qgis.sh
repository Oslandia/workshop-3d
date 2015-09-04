#!/bin/bash -e
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key 3FF5FFCAD71472C4
sudo sh -c 'echo "deb http://qgis.org/debian-ltr trusty main" > /etc/apt/sources.list.d/qgis.list'
sudo apt-get update -qq
sudo apt-get install -y --force-yes qgis python-qgis
