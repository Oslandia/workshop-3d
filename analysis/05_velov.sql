-- -------------------------------------
-- Compute 3D from DEM on velov_stations
-- -------------------------------------

-- Execute the script:
-- psql -U pggis -h localhost -d lyon < 05_velov.sql


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