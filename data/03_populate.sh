#!/usr/bin/env bash

# Create and populate the database
# ================================

cd /home/vagrant/lyon_data

# We will need postgis and postgis_sfcgal extensions in a newly created database.
# We use the pggis database as a template, extensions will be installed.

psql -h localhost -U pggis -c "CREATE DATABASE lyon WITH OWNER = pggis ENCODING = 'UTF8' TEMPLATE = pggis CONNECTION LIMIT = -1;" postgres
psql -h localhost -U pggis -d lyon -c "CREATE EXTENSION POSTGIS_SFCGAL;"

# With that we are ready to import the cropped vector data into the database:

shp2pgsql -W LATIN1 -I -s 3946 roofs.shp roofs | psql -h localhost -U pggis lyon
shp2pgsql -W LATIN1 -I -s 3946 arrondissements.shp arrondissements | psql -h localhost -U pggis lyon
shp2pgsql -W LATIN1 -I -s 3946 velov_stations.shp velov_stations | psql -h localhost -U pggis lyon
shp2pgsql -W LATIN1 -I -s 3946 lands.shp lands | psql -h localhost -U pggis lyon

# and the cropped raster data:

raster2pgsql -t 32x32 -I -s 3946 -C dem.tif dem | psql -h localhost -U pggis lyon
raster2pgsql -t 32x32 -I -s 3946 -C N02.tif no2 | psql -h localhost -U pggis lyon