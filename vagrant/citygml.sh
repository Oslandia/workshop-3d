#!/bin/bash -e
sudo apt-get install -y default-jre

wget -q "http://www.3dcitydb.net/3dcitydb/fileadmin/downloaddata/3DCityDB-Importer-Exporter-1.6-postgis-Setup.jar"
echo "INSTALL_PATH=$HOME/3DCityDB-Importer-Exporter" > install.xml
java -jar 3DCityDB-Importer-Exporter-1.6-postgis-Setup.jar -options install.xml
