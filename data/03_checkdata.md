Data checks
===========

Cleaning the data
-----------------

We connect to the database and execute the following queries to validate and clean the data. We can use PgAdmin or the psql console.

```
psql -h localhost -d pggis -U pggis
```

Data validation :
```SQL
/* OGC SFS Validity Check */

SELECT 
    gid 
FROM 
    cadbatiment 
WHERE 
    NOT ST_IsValid(geom);

UPDATE 
    cadbatiment 
SET 
    geom = ST_CollectionExtract(ST_MakeValid(geom),3) 
WHERE 
    NOT ST_IsValid(geom);

SELECT 
    gid 
FROM 
    cadbatiment 
WHERE 
    NOT ST_IsValid(geom);
```

Visual check
------------

* Open QGIS
* Add DEM raster layer as PostGIS raster layer
* Create a new PostGIS database connection (localhost, user pggis, password pggis)
* Add new PostGIS Layer: arrondissements
* Add new PostGIS Layer: roofs
* Add new PostGIS Layer: lands
* Add new PostGIS Layer: velov_stations
* Use DB Manager to load only lands having 'park' as type value
* Save as a new QGIS project

At this step, you can quit QGIS, and relaunch it with the project in this directory (TODO).

