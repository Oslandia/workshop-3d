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