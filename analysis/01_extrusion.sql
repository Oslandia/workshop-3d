-- Prepare data

-- We will now prepare the data so that we can visualize it with Horao. 
-- Each step has its own sql script file so you don't have to retype the requests. Just execute them using the provided commands.

-- -----------------------------
-- LOD 2 Building Data Extrusion
-- -----------------------------

-- Execute the script:
-- psql -U pggis -h localhost -d lyon < 01_extrusion.sql

-- ----------------
-- Check the result
-- ----------------
-- * Load lod2 geometry with QGIS
-- * Render it both in 2D, and with canvas 3d renderer

-- Note that this Virtual Machine is a low performance one

-- Now add also DEM mnt layer

-- What do you suggest ?

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