Data checks
===========

Cleaning the data
-----------------

We connect to the database and execute the following queries to validate and clean the data. We can use PgAdmin or the psql console.

We can also use PgAdmin3 to enter queries, or QGIS DB Manager.

```
psql -U pggis -h localhost -d lyon
```

Data validation :
```SQL
SELECT 
    gid 
FROM 
    roofs 
WHERE 
    NOT ST_IsValid(geom);
```

Visual check
------------

* Open QGIS
* Add raster layer dem.tif
* Create a new PostGIS database connection (localhost, user pggis, password pggis, database lyon)
* Add new PostGIS Layer: arrondissements
* Add new PostGIS Layer: roofs
* Add new PostGIS Layer: lands
* Add new PostGIS Layer: velov_stations
* Use DB Manager to load only lands having 'park' as type value
* Save as a new QGIS project

