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
    lod2 = st_translate(lod2, 0, 0, altitude);

-- Check altitude generated
SELECT min(altitude), max(altitude), avg(altitude) FROM roofs;