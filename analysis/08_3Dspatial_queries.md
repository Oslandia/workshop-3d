3D Spatial queries
==================

Now that we have the 3D data in shape and that we have done some visualization, we can also do some 3D analysis inside the database.

We use QGIS BD manager to launch queries and dynamically see the results.

3D extrusion
------------

```SQL

-- 3D Extrusion of forests

SELECT 
    gid
    , ST_Translate(
                 ST_Extrude(
                     ST_Buffer(geom, 250)
                 , 0, 0, 100)
           , 0, 0, altitude) AS geom
FROM
    lands 
WHERE 
    type='forest' /**AND TILE && geom*/
```

You can now view the generated data with QGIS / Horao.

Some important points :
* The geometry column must be called geom
* A non-null unique integer (e.g gid) is mandatory with QGIS in the result
* When entering queries in the DB manager, you should not write any ";" at the end !
* For horao, the query needs to contain an tiling WHERE clause as a meta-comment, either ``/**WHERE TILE && ...`` or ``/**AND TILE && ...``

3D Intersection
----------------

We compute the 3D intersection of two 3D volumes around forest, which could be interpreted for exemple as the place where some endemic species would be able to meet each other.

```SQL
CREATE TABLE forest_intersection AS (

WITH 
 f1 AS (
    SELECT 
        gid
        , ST_Translate(
                 ST_Extrude(
                     ST_Buffer(geom, 250)
                 , 0, 0, 100)
           , 0, 0, altitude) AS geom
    FROM 
        lands 
    WHERE 
        type='forest'
        AND gid = 7
),
 f2 AS (
    SELECT 
        gid
        , ST_Translate(
                 ST_Extrude(
                     ST_Buffer(geom, 250)
                 , 0, 0, 100)
           , 0, 0, altitude) AS geom
    FROM 
        lands 
    WHERE 
        type='forest'
        AND gid = 35
 )
SELECT 
    ST_3DIntersection(f1.geom, f2.geom) AS geom, 
    1 AS gid
FROM 
    f1, f2
    
);
```

Bar graphs
----------

Instead of using the built-in function of horao that allows to draw bar graphs from columns pos, height and width, we can use the extrusion to generate some bar graphs representing the amount of bikes which are available on each public bike station.

```SQL
SELECT 
    gid
    , ST_Extrude(
               ST_Buffer(geom, 20),
               0, 0, available_::integer * 30
            ) AS geom
FROM
    velov_stations
/**WHERE TILE && geom*/
```

Left to the reader :
* Use the queries from previous chapter to elevate the graph bars to the right elevation thanks to the DEM.

