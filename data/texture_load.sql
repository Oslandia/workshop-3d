-- Load textures into the database following the convention
-- used in PostGIS 3D

/* 
Notes :

In order to use this script you should have loaded the CityGML data as explained in setup_data.md

*/

CREATE OR REPLACE FUNCTION tex2vector(varchar) RETURNS float[][] AS $$
DECLARE
    outv float[][];
    arr varchar[];
    i int;
BEGIN
    arr := string_to_array($1,' ');
    FOR i IN 0..array_length(arr,1)/2-1
    LOOP
	outv := outv || array[[arr[i*2+1]::float, arr[i*2+2]::float]];
    END LOOP;
    return outv;
END;
$$ language plpgsql;

DROP AGGREGATE IF EXISTS array_accum(float[][]);
CREATE AGGREGATE array_accum (float[][])
(
    sfunc = array_cat,
    stype = float[][],
    initcond = '{}'
);

drop type if exists texture;
create type texture as (url text,uv float[][]);

drop table if exists textured_citygml;
create table textured_citygml (gid serial primary key, geom geometry('MULTIPOLYGONZ',3946,3), tex texture);

insert into textured_citygml
select root_id as gid,
  st_collect(g.geometry order by g.id) as geom,
  ( tex_image_uri, array_accum(tex2vector(texture_coordinates) order by g.id) )::texture as tex
from
   surface_geometry as g,
   surface_data as d,
   textureparam as t

where
    t.surface_data_id = d.id
and t.surface_geometry_id = g.id
group by root_id, tex_image_uri
;

