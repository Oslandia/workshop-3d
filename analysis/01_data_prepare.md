Prepare data
============

We will now prepare the data so that we can visualize it with Horao. 

Each step has its own sql script file so you don't have to retype the requests. Just execute them using the provided commands.

Please check the scripts for details and additional comments.

LOD 2 Building Data Extrusion
-----------------------------

```
psql -U pggis -h localhost -d lyon < 01_extrusion.sql
```

Check the result
----------------

* Load lod2 geometry with QGIS
* Render it both in 2D, and with canvas 3d renderer

Note that this Virtual Machine is a low performance one

* Now add also DEM mnt layer

What do you suggest ?


Compute Building elevation from DEM
-----------------------------------

```
psql -U pggis -h localhost -d lyon < 02_elevation.sql
```

Compute 3D from DEM on lands
----------------------------

```
psql -U pggis -h localhost -d lyon < 03_lands.sql
```


Compute 3D from DEM on velov_stations
-------------------------------------

```
psql -U pggis -h localhost -d lyon < 04_lands.sql
```

Check the result
----------------

Load LOD2, lands and mnt layer together in both 2D and 3D

Change color symbology

Use DbManager to load velov availability as bars on the map (note the meta comment /**WHERE TILE && geom*/):

```SQL
SELECT 
    gid AS gid, 
    geom AS pos, 
    available_::integer*10 AS height, 
    30 AS width 
FROM 
    velov_stations /**WHERE TILE && geom*/
```

Save your QGIS project


Compute average NO2 value per building
--------------------------------------

```
psql -U pggis -h localhost -d lyon < 05_NO2.sql
```

Check the result
----------------

In qgis load N02.tif (located in the "lyon data" folder) as a raster layer an put it just above the dem layer.

In the 'roofs' layer's properties, in the Style tab click on 'Simple Fill' and then on 'Data defined properties...'. Check Color and enter the expression:

    ''||no2_red||','||no2_green||','||no2_blue||',255'

This will allow you to color roofs based on their NO2 rate. But Horao is not yet able to adapt to such dynamic color properties. However Cuardo, our webclient, as we will see in a dedicated section, supports dynamic properties like these.