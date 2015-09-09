-- ----------------------------
-- Compute 3D from DEM on lands
-- ----------------------------

-- Execute script:
-- psql -U pggis -h localhost -d lyon < 03_lands.sql


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