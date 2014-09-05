Import CityGML data into our database
-------------------------------------

The raw CityGML data still needs a bit of work for Cardano to be able to recognize them.

Cardano is shipped with an SQL script that will do the work. It is located in "docs/texture_load.sql" of the source distribution. It will create a "textured_citygml" table.

    psql -h localhost -U pggis -d citygml < ~/data/www/docs/texture_load.sql

Then the table must be copied into the final database :

    pg_dump -h localhost -U pggis citygml -t textured_citygml | psql -h localhost -U pggis lyon

Import textures
---------------

We have to make sure textures shipped with the CityGML archive are correctly served by Apache. Copy or make a link from the textures directory to ~/data/www/textures
