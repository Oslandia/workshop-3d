#!/usr/bin/env bash

# Import of the CityGML data
# ==========================

cd /home/vagrant/lyon_data

# Prepare the database

psql lyon -U pggis -h localhost -c "CREATE TABLE citygml(gid SERIAL PRIMARY KEY, geom GEOMETRY('POLYHEDRALSURFACEZ', 3946))"


# We use a python script, citygml2psql, to export the geometries of the CityGML to our database

../citygml2pgsql.py lyon3_small_subset.xml 2 3946 geom citygml | psql -U pggis -h localhost lyon