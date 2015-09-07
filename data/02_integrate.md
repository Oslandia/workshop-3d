Integrating data
================

Open the lyon_data.zip archive. It contains raster and vectorial data (lyon.sql) and cityGML 3D buildings (citygml.sql) of a cropped area of Lyon.

To facilitate the connection to the database, we will use a *.pgpass* file, which allows us to store username and password, so as not having to type it each time. The file must be protected.

```
echo "localhost:5432:*:pggis:pggis" > ~/.pgpass
chmod 600 ~/.pgpass
```

We will need postgis and postgis_sfcgal extensions in a newly created databse. We use the pggis database as a template, extensions will be installed.

```
psql -h localhost -U pggis -c "CREATE DATABASE lyon WITH OWNER = pggis ENCODING = 'UTF8' TEMPLATE = pggis CONNECTION LIMIT = -1;" postgres
psql -h localhost -U pggis -d lyon -c "CREATE EXTENSION POSTGIS_SFCGAL;"
```

Import raster and vectorial data:
```
unzip workshop-3d/data/lyon_data.zip
psql -h localhost -U pggis lyon < lyon.sql
```

Import citygml data:
```
psql lyon -U pggis -h localhost -c "CREATE TABLE citygml(gid SERIAL PRIMARY KEY, geom GEOMETRY('POLYHEDRALSURFACEZ', 3946))"
psql -h localhost -U pggis lyon < citygml.sql
```
