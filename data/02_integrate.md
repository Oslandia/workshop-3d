Integrating data
================

All the data used in the workshop is freely available on the [Lyon Open Data website](smartdata.grandlyon.com).

The downloaded data is located in the lyon data folder. 

Cropping and reprojecting
-------------------------

We are only interested with a small extent of the raw data.

The cropping.sh script handles the cropping and reprojection of the data. The script contains commentaries explaining each step.

Create and populate the database
--------------------------------

Check and run the populate.sh script for more information on how to create and populate the database.

Import of the CityGML data
--------------------------

Check and run the citygml.sh script for more information on how to import CityGML into our database.


```
psql lyon -U pggis -h localhost -c "CREATE TABLE citygml(gid SERIAL PRIMARY KEY, geom GEOMETRY('POLYHEDRALSURFACEZ', 3946))"
psql -h localhost -U pggis lyon < citygml.sql
```
