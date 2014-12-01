Prepare data
============

We will now prepare the data so that we can visualize it with Horao. Open a database session:

    psql -U pggis -h localhost -d lyon


LOD 2 Building Data Extrusion
-----------------------------

```SQL
ALTER TABLE 
    roofs
ADD COLUMN 
    lod2 geometry('POLYHEDRALSURFACEZ',3946);


UPDATE 
    roofs
SET 
    lod2 = ST_GeometryN(ST_Extrude(ST_Force2D(geom), 0, 0, hfacade),1);


-- Create spatial indexes
CREATE INDEX roofs_lod2_idx ON roofs USING GIST(lod2);
```

LOD 1 Building Data Computation
-------------------------------

```SQL
ALTER TABLE 
    roofs 
ADD COLUMN 
    lod1 geometry('POLYHEDRALSURFACEZ',3946);


-- get Polyhedralsurfaces
WITH p AS (
    SELECT 
        gid,
        ST_xmin(lod2) AS x1
        , ST_xmax(lod2) AS x2
        , ST_ymin(lod2) AS y1
        , ST_ymax(lod2) AS y2
        , ST_zmin(lod2) AS z1
        , ST_zmax(lod2) AS z2
    FROM 
        roofs
)
UPDATE 
    roofs 
SET 
    lod1 = 'SRID=3946;POLYHEDRALSURFACE(
(('||x1||' '||y1||' '||z1||','
||x1||' '||y1||' '||z2||','
||x2||' '||y1||' '||z2||','
||x2||' '||y1||' '||z1||','
||x1||' '||y1||' '||z1||'))
,
(('||x1||' '||y1||' '||z2||','
||x1||' '||y2||' '||z2||','
||x2||' '||y2||' '||z2||','
||x2||' '||y1||' '||z2||','
||x1||' '||y1||' '||z2||'))
,
(('||x2||' '||y1||' '||z2||','
||x2||' '||y2||' '||z2||','
||x2||' '||y2||' '||z1||','
||x2||' '||y1||' '||z1||','
||x2||' '||y1||' '||z2||'))
,
(('||x1||' '||y1||' '||z1||','
||x1||' '||y2||' '||z1||','
||x1||' '||y2||' '||z2||','
||x1||' '||y1||' '||z2||','
||x1||' '||y1||' '||z1||'))
,
(('||x1||' '||y2||' '||z1||','
||x2||' '||y2||' '||z1||','
||x2||' '||y2||' '||z2||','
||x1||' '||y2||' '||z2||','
||x1||' '||y2||' '||z1||'))
,
(('||x1||' '||y1||' '||z1||','
||x2||' '||y1||' '||z1||','
||x2||' '||y2||' '||z1||','
||x1||' '||y2||' '||z1||','
||x1||' '||y1||' '||z1||'))
)'
FROM 
    p
WHERE 
    p.gid = roofs.gid
;


-- LOD 1 Reverse orientation.
UPDATE roofs SET lod1 = st_reverse(lod1);


-- Create spatial index
CREATE INDEX cadbatiment_lod1_idx ON roofs USING GIST(lod1);
```

Check the result
----------------

* Load lod1 geometry with QGIS
* Render it both in 2D, and with canvas 3d renderer

Note that this Virtual Machine is a low performance one

* Now add also DEM mnt layer

What do you suggest ?


Compute Building elevation from DEM
-----------------------------------

```SQL
-- Compute height for each geometry
ALTER TABLE roofs ADD COLUMN altitude integer;


-- 
WITH hh AS 
(
    SELECT 
        gid, 
        min(px) AS height
    FROM 
    (
        SELECT
            gid,
            st_value(rast, st_setsrid( (st_dumppoints(pts)).geom, 3946)) AS px
        FROM (
            select 
                gid,
                geom AS pts
            from 
                roofs
        ) 
        AS t,
        dem
        WHERE 
            st_intersects(rast, pts)
    ) 
    AS tt
    GROUP BY 
        gid
)
UPDATE 
    roofs 
SET 
    altitude = height 
FROM 
    hh 
WHERE 
    roofs.gid = hh.gid;

-- Update roofs Height
UPDATE 
    roofs
SET
    lod1 = st_translate(lod1, 0, 0, altitude),
    lod2 = st_translate(lod2, 0, 0, altitude);

-- Check altitude generated
SELECT min(altitude), max(altitude), avg(altitude) FROM roofs;
```

Compute 3D from DEM on lands
----------------------------

```SQL
-- Add a dimension
ALTER TABLE 
    lands
ALTER COLUMN 
    geom 
TYPE
    Geometry(MultiPolygonZ, 3946)
USING 
    st_force3D(geom);


-- Compute lands planes altitude
ALTER TABLE 
    lands 
ADD COLUMN 
    altitude integer;


WITH hh
    AS 
    (
        SELECT gid, min(px) as height
        FROM 
        ( 
            SELECT
                gid, st_value(rast, st_pointn(st_exteriorring(st_geometryn(pts,1)),1) ) AS px
            FROM 
                (
                    SELECT gid, geom as pts
                    FROM lands
                ) 
                AS t,
                dem
            WHERE 
                st_intersects(rast, pts)
        ) 
        AS tt
        GROUP BY gid
    )
UPDATE 
    lands
SET 
    altitude=height
FROM 
    hh
WHERE 
    lands.gid = hh.gid;
    
    
-- Translate
UPDATE 
    lands 
SET 
    geom=st_translate(geom,0,0,altitude)
WHERE 
    altitude IS NOT NULL;
    
    
-- Reverse orientation
UPDATE 
    lands 
SET 
    geom=st_reverse(geom);
    
    
-- Create Spatial Index
CREATE INDEX lands_gist_idx ON lands USING GIST(geom);


-- Check
SELECT min(altitude), max(altitude), avg(altitude) FROM lands;
```


Compute 3D from DEM on velov_stations
-------------------------------------

```SQL
-- Add a dimension
ALTER TABLE 
    velov_stations
ALTER COLUMN 
    geom 
TYPE 
    Geometry(PointZ, 3946)
USING 
    st_force3D(geom);
    
    
-- Compute velov_stations planes altitude
ALTER TABLE velov_stations ADD COLUMN altitude integer;


WITH hh
AS 
    (
        SELECT
            gid, min(px) as height
        FROM 
            (
                SELECT
                    gid, st_value(rast, pts) as px
                FROM
                    (
                        SELECT gid, geom as pts
                        FROM velov_stations
                    ) 
                    AS t,
                    dem
                WHERE 
                    st_intersects(rast, pts)
            ) 
            AS tt
        GROUP BY 
            gid
    )
UPDATE 
    velov_stations
SET 
    altitude=height
FROM 
    hh
WHERE 
    velov_stations.gid = hh.gid;


-- Translate
UPDATE 
    velov_stations 
SET 
    geom=st_translate(geom,0,0,altitude)
WHERE 
    altitude IS NOT NULL;
    
    
-- Reverse orientation
UPDATE velov_stations SET geom=st_reverse(geom);


-- Create Spatial Index
CREATE INDEX bike_gist_idx ON velov_stations USING GIST(geom);


-- Check
SELECT min(altitude), max(altitude), avg(altitude) FROM velov_stations;
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


```SQL
ALTER TABLE roofs ADD COLUMN no2_red float;


ALTER TABLE roofs ADD COLUMN no2_green float; 


ALTER TABLE roofs ADD COLUMN no2_blue float;


WITH 
    points AS (SELECT gid, ST_SetSRID(ST_Centroid(geom), 3946) AS geom FROM roofs),
    colors AS 
        (
            SELECT 
                gid,
                ST_Value(rast, 1, geom) AS red,  
                ST_Value(rast, 2, geom) AS green, 
                ST_Value(rast, 3, geom) AS blue 
            FROM 
                points, no2 
            WHERE 
                ST_Intersects(geom, rast) 
        )
UPDATE 
    roofs
SET 
    (no2_red, no2_green, no2_blue)=(colors.red, colors.green, colors.blue) 
FROM 
    colors 
WHERE 
    roofs.gid = colors.gid;
```

Check the result
----------------

In qgis load N02.tif as a raster layer an put it just above the dem layer.

In the 'roofs' layer's properties, in the Style tab click on 'Simple Fill' and then on 'Data defined properties...'. Check Color and enter the expression:

    ''||no2_red||','||no2_green||','||no2_blue||',255'

This will allow you to color roofs based on their NO2 rate. But Horao is not yet able to adapt to such dynamic color properties. However Cuardo, our webclient, as we will see in a dedicated section, supports dynamic properties like these.
