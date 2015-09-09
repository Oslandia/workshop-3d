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