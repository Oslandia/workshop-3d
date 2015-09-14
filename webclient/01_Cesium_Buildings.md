Cesium Buildings
================

Introduction
------------

Cesium Buildings is the Javascript library and client application that we will use to have a 3D visualization of our data.
It is based on the popular Cesium globe application.

Running Cesium Buildings
-----------------

Cesium Buildings is installed in the apache directory ~/data/www/.

If the VM is configured correctly (see README.md), Cesium Buildings is accessible from the host machine:
* Open http://192.168.56.101/w/cesium-buildings/Example.html on the host machine.

This demo features the CityGML data loaded previously.

We can also visualize the lod2 data we created from the roof layer:
* Open http://192.168.56.101/w/cesium-buildings/Example2.html on the host machine.

Clicking the "toggle thematic coloring" button, will color the buildings according to their NO2 value.

Hovering over buildings while "higlight on mouseover" is toggled allows you to inspect the attributes of the buildings.

You can also change the time of the day by using the Cesium time widget at the bottom of the screen. It will change the shading of the buildings.