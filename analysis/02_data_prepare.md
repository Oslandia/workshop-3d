Prepare data
============

LOD 2 Building Data Extrusion
-----------------------------

```SQL
ALTER TABLE roofs
ADD COLUMN lod2 geometry('POLYHEDRALSURFACEZ',3946);
UPDATE roofs
SET lod2=ST_GeometryN(ST_Extrude(ST_Force2D(geom), 0, 0, hfacade),1);
-- Create spatial indexes
CREATE INDEX roofs_lod2_idx ON roofs USING GIST(lod2);
```

LOD 1 Building Data Computation
-------------------------------

```SQL
ALTER TABLE roofs ADD COLUMN lod1 geometry('POLYHEDRALSURFACEZ',3946);
WITH p AS (
SELECT gid,
ST_xmin(lod2) AS x1, ST_xmax(lod2) AS x2,
ST_ymin(lod2) AS y1, ST_ymax(lod2) AS y2,
ST_zmin(lod2) AS z1, ST_zmax(lod2) AS z2
FROM roofs
)
UPDATE roofs SET lod1 = 'SRID=3946;POLYHEDRALSURFACE(
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
FROM p
WHERE p.gid = roofs.gid
;
-- LOD 1 Reverse orientation.
UPDATE roofs SET lod1=st_reverse(lod1);
-- Create spatial indexes
CREATE INDEX cadbatiment_lod1_idx ON roofs USING GIST(lod1);
```

Check the result
----------------

Load lod1 geometry with QGIS

Render it both in 2D, and with canvas 3d renderer

Note that this Virtual Machine is a low performance one

Now add also DEM mnt layer

What do you suggest ?


Compute Buldingd elevation from DEM
-----------------------------------

```SQL
-- Compute height for each geometry
ALTER TABLE roofs ADD COLUMN altitude integer;
WITH hh
AS (
SELECT gid, min(px) AS height
FROM (
SELECT
gid, st_value(rast,
st_setsrid( (st_dumppoints(pts)).geom, 3946)
) as px
FROM
(
select gid, geom as pts
from roofs
) as t,
dem
WHERE st_intersects(rast, pts)
) AS tt
GROUP BY gid
)
UPDATE roofs SET altitude=height FROM hh WHERE roofs.gid = hh.gid;
-- Update roofs Height
UPDATE roofs
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
ALTER TABLE lands
ALTER COLUMN geom TYPE Geometry(MultiPolygonZ, 3946)
USING st_force3D(geom);
-- Compute lands planes altitude
ALTER TABLE lands ADD COLUMN altitude integer;
WITH hh
AS (
SELECT gid, min(px) as height
FROM (
SELECT
gid, st_value(rast,
st_pointn(st_exteriorring(st_geometryn(pts,1)),1)
) as px
FROM
(
SELECT gid, geom as pts
FROM lands
) as t,
dem
WHERE st_intersects(rast, pts)
) AS tt
GROUP BY gid
)
UPDATE lands
SET altitude=height
FROM hh
WHERE lands.gid = hh.gid;
-- Translate
UPDATE lands SET geom=st_translate(geom,0,0,altitude)
WHERE altitude IS NOT NULL;
-- Reverse orientation
UPDATE lands SET geom=st_reverse(geom);
-- Create Spatial Index
CREATE INDEX lands_gist_idx ON lands USING GIST(geom);
-- Check
SELECT min(altitude), max(altitude), avg(altitude) FROM lands;
```


Compute 3D from DEM on velov_stations
-------------------------------------

```SQL
-- Add a dimension
ALTER TABLE velov_stations
ALTER COLUMN geom TYPE Geometry(PointZ, 3946)
USING st_force3D(geom);
-- Compute velov_stations planes altitude
ALTER TABLE velov_stations ADD COLUMN altitude integer;
WITH hh
AS (
SELECT gid, min(px) as height
FROM (
SELECT
gid, st_value(rast, pts) as px
FROM
(
SELECT gid, geom as pts
FROM velov_stations
) as t,
dem
WHERE st_intersects(rast, pts)
) AS tt
GROUP BY gid
)
UPDATE velov_stations
SET altitude=height
FROM hh
WHERE velov_stations.gid = hh.gid;
-- Translate
UPDATE velov_stations SET geom=st_translate(geom,0,0,altitude)
WHERE altitude IS NOT NULL;
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

Use DbManager to load velov availability as bars on the map:

```SQL
SELECT gid as gid, geom as pos, available_::integer*10 as height, 30 as width from velov_stations /**WHERE TILE && geom*/
```

Save your QGIS project


Compute average NO2 value per buildind
--------------------------------------


```SQL
ALTER TABLE roofs ADD COLUMN no2_red float;
ALTER TABLE roofs ADD COLUMN no2_green float; 
ALTER TABLE roofs ADD COLUMN no2_blue float;
WITH points AS (SELECT gid, ST_SetSRID(ST_Centroid(geom), 3946) AS geom FROM roofs),
colors AS ( SELECT gid,
                   ST_Value(rast, 1, geom) AS red,  
                   ST_Value(rast, 2, geom) AS green, 
                   ST_Value(rast, 3, geom) AS blue FROM points, no2 WHERE ST_Intersects(geom, rast) )
UPDATE roofs
SET (no2_red, no2_green, no2_blue)=(colors.red, colors.green, colors.blue) 
FROM colors WHERE roofs.gid = colors.gid;
```


<---
WITH points AS (SELECT gid, ST_SetSRID((ST_DumpPoints(geom)).geom, 3946) AS geom FROM roofs),
colors AS ( SELECT gid,
                   AVG(ST_NearestValue(rast, 1, geom)) AS red,  
                   AVG(ST_NearestValue(rast, 2, geom)) AS green, 
                   AVG(ST_NearestValue(rast, 3, geom)) AS blue FROM points, no2 WHERE geom && rast AND NOT ST_IsEmpty(rast) GROUP BY gid)
UPDATE roofs
SET (no2_red, no2_green, no2_blue)=(colors.red, colors.green, colors.blue) 
FROM colors WHERE roofs.gid = colors.gid;



WITH colors AS (
        SELECT gid, ST_Value(rast, 1, ST_Centroid(geom)) AS red,  ST_Value(rast, 2, ST_Centroid(geom)) AS green, ST_Value(rast, 3, ST_Centroid(geom)) AS blue 
        FROM roofs, no2 WHERE rast && ST_Centroid(geom) ) 
UPDATE roofs
SET (no2_red, no2_green, no2_blue)=(colors.red, colors.green, colors.blue) 
FROM colors WHERE roofs.gid = colors.gid;


ALTER TABLE roofs ADD COLUMN no2_red float;
ALTER TABLE roofs ADD COLUMN no2_green float; 
ALTER TABLE roofs ADD COLUMN no2_blue float;
WITH clipped AS (SELECT gid AS id, 
        ST_Clip(rast,ST_Buffer(ST_Force2d(geom),10)) AS rast
        FROM no2,roofs WHERE rast && geom AND ST_Intersects(rast,ST_Force2d(geom)))
UPDATE roofs
SET (no2_red, no2_green, no2_blue)=(stats.red, stats.green, stats.blue) 
FROM (SELECT id, (ST_SummaryStats(rast,1,TRUE)).max AS red, 
                 (ST_SummaryStats(rast,2,TRUE)).max AS green, 
                 (ST_SummaryStats(rast,3,TRUE)).max AS blue FROM clipped) AS stats 
WHERE gid=stats.id;

create table test as select gid as gid, ST_Intersection(t.geom, r.geom ) as geom from (select ST_Collect(ST_DumpAsPolygons(rast)) as geom from no2) as r, foofs as t where t.geom && r.geom;




WITH clipped AS (SELECT gid AS id, 
        (ST_SummaryStats(ST_Clip(rast,ST_Force2d(geom)))).mean AS mean 
        FROM no2,roofs WHERE rast && geom AND ST_Intersects(rast,ST_Force2d(geom)))
UPDATE roofs
SET (avg_no2=stats. FROM stats WHERE gid=stats.id;


```
WITH inter AS ( select gid, st_intersection(geom, rast, 1) as red, st_intersection(geom, rast, 1)  AS green, st_intersection(geom, rast, 1)  AS blue 
FROM roofs, no2 where geom && rast and st_isvalid(geom) ),
avg AS ( select gid, 
        SUM((red).val*st_area((red).geom))/SUM(st_area((red).geom)) AS red, 
        SUM((green).val*st_area((green).geom))/SUM(st_area((green).geom)) AS green, 
        SUM((blue).val*st_area((blue).geom))/SUM(st_area((blue).geom)) AS blue 
FROM inter group by gid )
UPDATE roofs
SET (no2_red, no2_green, no2_blue)=(avg.red, avg.green, avg.blue) FROM avg;

-->
