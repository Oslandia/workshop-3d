Terrain preparation
===================

We prepare the terrain to use with Horao. We have to put it under a specific .ive format.

Checking Horao
--------------

* Open QGIS 
* In a new project keep only the whole DEM raster data from file (/tmp/data/*tif)
* Open 3D Canvas plugin
* Be sure to zoom on the whole extent
* Use 's' key to have look on framebuffer rate 

Creating .ive
-------------

We create a .ive file for the subset, and the whole data

```
osgdem -d /tmp/data/subset/mnt.tif -l 6 -o /tmp/data/subset/mnt.ive
osgdem -d /tmp/data/MNT2009_Altitude_10m_CC46.tif -l 6 -o /tmp/data/MNT2009_Altitude_10m_CC46.ive
```

Redo the chceking with QGIS as above, opening the canvas and pressing 's'.


