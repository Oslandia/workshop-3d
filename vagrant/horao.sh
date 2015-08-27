#!/bin/bash -e
sudo apt-get install -y python-qt4 python-qt4-sql libboost-dev cmake libgdal-dev libpq-dev libopenscenegraph-dev liblwgeom-dev pyqt4-dev-tools libproj-dev libgdal1-dev build-essential

cd ~vagrant
mkdir -p build && cd build
rm -Rf horao
git clone https://github.com/Oslandia/horao.git
cd horao
cmake .
make 
sudo make install
# activate qgis plugins

mkdir -p ~/.qgis2/python/plugins
cd ~/.qgis2/python/plugins/
rm -f horao && ln -s ~/build/horao/qgis_plugin horao
