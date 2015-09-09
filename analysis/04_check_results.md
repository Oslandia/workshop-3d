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