Integrating data
================

Cropping and reprojecting
-------------------------

We are only interested with a small extend of the downloaded data. The zone of interest are in the directory zones.

Moreover we want to have data in the same coordinate system (namely EPG:3946). We will use the GDAL/OGR command line tools to manipulate our data.

To get the extend we are interested in can be obtained with:

    ogrinfo -al zones | grep Extent

the result is:

    Extent: (1841372.165967, 5174640.031139) - (1844890.870163, 5176327.053583)

For vector data, we use ogr2ogr to carry out both operations (cropping and reprojection):

    ogr2ogr -clipdst 1841372.165967 5174640.031139 1844890.870163 5176327.053583 -t_srs EPSG:3946 roofs.shp fpc_fond_plan_communaut_fpctoit.shp
    ogr2ogr -clipdst 1841372.165967 5174640.031139 1844890.870163 5176327.053583 -t_srs EPSG:3946 arrondissements.shp adr_voie_lieu.adrarrond.shp
    ogr2ogr -clipdst 1841372.165967 5174640.031139 1844890.870163 5176327.053583 -t_srs EPSG:3946 velov_stations.shp jcd_jcdecaux.jcdvelov.shp
    ogr2ogr -clipdst 1841372.165967 5174640.031139 1844890.870163 5176327.053583 -t_srs EPSG:3946 lands.shp natural.shp

For raster data we use gdalwarp:

    gdalwarp -of gtiff -t_srs EPSG:3946 -te 1841372.165967 5174640.031139 1844890.870163 5176327.053583 MNT2009_Altitude_10m_CC46.tif  dem.tif
    gdalwarp -of gtiff -t_srs EPSG:3946 -te 1841372.165967 5174640.031139 1844890.870163 5176327.053583 Carte_agglo_Lyon_NO2_2012.tif  N02.tif


Create and populate the database
--------------------------------

To facilitate the connexion to the database, we will use a *.pgpass* file, which allow us to store username and password, so as not having to type it each time. The file must be protected.

    echo "localhost:5432:*:pggis:pggis" > ~/.pgpass
    chmod 600 ~/.pgpass

We will need postgis and postgis_sfcgal extensions in a newly created databse.

    psql -U pggis -h localhost -c "CREATE DATABASE lyon WITH OWNER = pggis ENCODING = 'UTF8' TEMPLATE = template0 CONNECTION LIMIT = -1;" postgres
    psql -U pggis -h localhost -d lyon -c 'CREATE EXTENSION postgis;'
    psql -U pggis -h localhost -d lyon -c 'CREATE EXTENSION postgis_sfcgal;'

With that we are ready to import the cropped vector data into the database:

    shp2pgsql -W LATIN1 -I -s 3946 roofs.shp roofs | psql -U pggis -h localhost lyon
    shp2pgsql -W LATIN1 -I -s 3946 arrondissements.shp arrondissements | psql -U pggis -h localhost lyon
    shp2pgsql -W LATIN1 -I -s 3946 velov_stations.shp velov_stations | psql -U pggis -h localhost lyon
    shp2pgsql -W LATIN1 -I -s 3946 lands.shp lands | psql -U pggis -h localhost lyon

and the cropped raster data:

    raster2pgsql -t 32x32 -I -s 3946 dem.tif dem | psql -U pggis -h localhost lyon
    raster2pgsql -t 32x32 -I -s 3946 N02.tif no2 | psql -U pggis -h localhost lyon




