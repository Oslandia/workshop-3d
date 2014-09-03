3D Web client
=============

Introduction
------------

In this part of the workshop, we will learn how to create a Web Client, based on WebGL, Three.js, and XXXX, to display 3D data in a (modern) browser.

The data to display is the data stored in *PostGIS 3D*, which is served by *MapServer TinyOWS*. We also make use of *MapServer MapCache*, to load raster tiles as WMS, caching the data locally for more efficiency and tuning.
Textures are also served by a simple Apache server.

All these software components are already setup and ready to run when using the Docker 3dgis image.

We will first check that these softwares are running correctly to verify the setup.

Docker 3dgis
------------

All the needed components below run inside a docker container. It is an instance of the *docker-3dgis* instance.

We can check that the container is running with the *docker.io* command line :

```bash
$ sudo docker.io ps
CONTAINER ID        IMAGE                   COMMAND                CREATED             STATUS              PORTS                                        NAMES
9065a441cc52        oslandia/3dgis:latest   /sbin/my_init          3 hours ago         Up 3 hours          0.0.0.0:5432->5432/tcp, 0.0.0.0:80->80/tcp   3dgis_test
```

You can see that your host port 5432 redirects to the container's port 5432 (that's PostgreSQL) and port 80 is mapped to 80 (that's Apache and friends).

PostGIS
-------

If you followed this workshop until now, you should already be able to connect to the container's database.
Just in case you did not, check that it is alive (credentials : *pggis/pggis*).

```
psql -h localhost -U pggis -d pggis -c "SELECT postgis_version();"
```

MapCache
--------

We then check that TinyOWS is running fine in the docker container. We use QGIS for this.
* Open QGIS
* ->Layers->Add WMS layer
* ->New
  * Name : 3dgis
  * URL : http://localhost/mapcache
  * -> OK
* -> Connect
* Select a layer (e.g. orthophoto)
* -> Add

You should now have a new raster layer loaded in QGIS. Loading can be long, since MapCache is only a proxy to the original WMS layer.
Subsequent calls to the same area will display much faster.

Note that MapCache cache is saved in the */data* folder of the container, which itself is mapped on the *~/data/* directory on the host (see installation steps). You can pre-populate this directory with cache elements if you already have some, considerably improving the speed of the service.

TinyOWS
-------

We then check that TinyOWS is running fine in the docker container. We also use QGIS for this.
* Open QGIS
* ->Layers->Add WFS layer
* ->New
  * Name : 3dgis
  * URL :  http://localhost/cgi-bin/tinyows
  * -> OK
* -> Connect
* Select a layer (e.g. velov)
* -> Add

You should now have a new vector layer loaded in QGIS. Loading can be long if the layer contains a lot of data.

Textures
--------

Textures are served from the */data/www/textures* directory.
You can add required textures there, and check that they are available at the following URL.

* http://localhost/w/textures

Troubleshooting
---------------

If all of this works, we are ready for the examples.
If not, be sure to check the installation instructions.
