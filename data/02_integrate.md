Integrating data
================

Cropping and reprojecting
-------------------------

We are only interested with a small extent of the downloaded data. The zones of interest are in the directory 'zones'.

Moreover we want to have data in the same coordinate system (namely EPG:3946). We will use the GDAL/OGR command line tools to manipulate our data.

To get the extent we are interested in can be obtained with:

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

To facilitate the connection to the database, we will use a *.pgpass* file, which allows us to store username and password, so as not having to type it each time. The file must be protected.

    echo "localhost:5432:*:pggis:pggis" > ~/.pgpass
    chmod 600 ~/.pgpass

We will need postgis and postgis_sfcgal extensions in a newly created databse. We use the pggis database as a template, extensions will be installed.

    psql -h localhost -U pggis -c "CREATE DATABASE lyon WITH OWNER = pggis ENCODING = 'UTF8' TEMPLATE = pggis CONNECTION LIMIT = -1;" postgres

With that we are ready to import the cropped vector data into the database:

    shp2pgsql -W LATIN1 -I -s 3946 roofs.shp roofs | psql -h localhost -U pggis lyon
    shp2pgsql -W LATIN1 -I -s 3946 arrondissements.shp arrondissements | psql -h localhost -U pggis lyon
    shp2pgsql -W LATIN1 -I -s 3946 velov_stations.shp velov_stations | psql -h localhost -U pggis lyon
    shp2pgsql -W LATIN1 -I -s 3946 lands.shp lands | psql -h localhost -U pggis lyon

and the cropped raster data:

    raster2pgsql -t 32x32 -I -s 3946 dem.tif dem | psql -h localhost -U pggis lyon
    raster2pgsql -t 32x32 -I -s 3946 N02.tif no2 | psql -h localhost -U pggis lyon


Import of CityGML data
======================

We will be using 3D textured data in some examples of this workshop. Data are coming from the Grand Lyon open data initiative. These data have been preprocessed for the needs of this workshop (in particular texture resolutions have been decreased).

Once the .zip archive containing CityGML data has been downloaded and decompressed, we will need to download and install a thrid-party Java application that is able to import such data in a PostGIS database.

Import into PostGIS
------------------------------

First download the setup from
http://www.3dcitydb.net/3dcitydb/fileadmin/downloaddata/3DCityDB-Importer-Exporter-1.6-postgis-Setup.jar
Then run it with :

    java -jar 3DCityDB-Importer-Exporter-1.6-postgis-Setup.jar

Follow the instructions of the installer.

We will then need to create a new PostGIS database that will be used specifically for the import.

    createdb -U pggis -h localhost citygml
    psql -h localhost -U pggis -d citygml -c 'CREATE EXTENSION postgis;'
    
After that, the database' schema needs to be initialized. The importer provides a script for that :

    cd ~/3DCityDB-Importer-Exporter/3dcitydb/postgis
    psql -h localhost -U pggis -d citygml < CREATE_DB.sql
    
Enter 3946 when SRID is requested and crs:EPSG::3946 for SRSName.
    
Now, launch the importer by using the .sh script located in the installation directory, for instance :

    ~/3DCityDB-Importer-Exporter/3DCityDB-Importer-Exporter.sh
    
Within the 'Preferences / CityGML import / Apperance' tab, make sure the option "Import appearances, do not import texture files" is checked. Textures will be stored as regular image files on the disk.

Within the 'Database' tab, enter the options needed to connect to the database :
* server : localhost
* user : pggis
* password : you have to enter something (small bug)
* database : citygml
Then test the connection with the "Connect" button

Then proceed to the import by moving to the 'Import' tab, selecting the .xml file with the 'Browse' button and pressing 'Import'.


