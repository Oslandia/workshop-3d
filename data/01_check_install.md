Check installation
==================

PostGIS
-------

The first step is to check that we have a working spatial database with 3D features enabled.

```
psql -h localhost -U pggis -d pggis -c "select postgis_full_version();"
psql -h localhost -U pggis -d pggis -c "select postgis_sfcgal_version();"
```

QGIS
----

Now open QGIS and see if it works.

You can connect to the pggis database, which has PostGIS enabled (but no data for now).

Horao
-----

Check that Horao QGIS plugin is activated in QGIS extensions.

Check that the 3D canvas is enabled (you should see a plug icon in the toolbar).
