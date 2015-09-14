# Workshop 3D foss4g 2015

## About

This workshop showcases Oslandia's 3D GIS stack (PostGIS 3D, Cesium Buildings web client).

Feel free to contact us for more information, training sessions or development on these software :

* Web: http://www.oslandia.com
* Blog: http://www.oslandia.com/articles.html
* Mail: infos+3d@oslandia.com
* Twitter: @Oslandia_en and @Oslandia_fr (french)

## Content

Throughout this workshop, the following components will be installed:

* QGIS: the famous desktop GIS 
* PostGIS: the well known database, with 3D additions
* Horao: a 3D OpenGL viewer, with a QGIS plugin and PostGIS 3D support
* MapServer Mapcache: a map caching server
* MapServer TinyOWS: a vector data server, with PostGIS and 3D support
* Cesium Buildings: a 3D web client to display 3D data in a browser, based on WebGL and Cesium

You can follow the workshop through the various steps of each module :

* Data : get the data in shape
* Analysis : use the OpenGL viewer, and make some 3D analysis
* Webgl : display 3D in a browser

In each module, steps are marked with a number, allowing you to follow easily the whole training session.

## Environment

This workshop is designed to be run on a Linux Operating System. Ubuntu 14.04 is preferred. You will need a good graphic card, and if you use a virtual machine, it is better to have 3D acceleration activated and working in the guest OS, as well as guest extensions installed.

To follow this workshop, you will need to have the abovementionned elements installed.

You can use a VirtualBox image with all software already installed and setup, or you can choose to install them yourself. See below for installation instructions.

## Configuring the virtual machine

Import the virtual machine in virtual box: File -> Import Appliance

To access the virtual machine from the host machine, we need to configure network options in virtual box:
* File -> Preferences -> Network -> Host-only Network
  * Add host-only network (note the name of the created network)
  * Edit host-only network -> Set IPv4 Address to 192.168.56.1
* Right-click on the imported virtual machine -> settings -> Network -> Set "Name" field to the previously created host-only network

If you need to quickly load the data into postgis, the script ~/backup_scripts/load_all.sh is available. Otherwise, just follow the instructions in the data and analysis folders.

## Installing with vagrant

Install vagrant and virtual box:

```
sudo apt-get install virtualbox-4.3
sudo apt-get install vagrant
vagrant add ubuntu/trusty64 https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box
```

Launch the vagrant script:

```
cd vagrant
vagrant up
```

The VM login/password are vagrant/vagrant.

Once in the VM, download and launch the server docker:

```
./run3dgis.sh
```

## Manual installation

### OS

Install Ubuntu 14.04 Trusty Tahr LTS

* http://releases.ubuntu.com/14.04/

Once installed, we will need a few packages:

```
  sudo apt-get install git wget gdal-bin unzip pgadmin3
```


### QGIS

To install QGIS, use latest stable Ubuntu packages from the QGIS project:

As root (sudo -s) :
```
  echo "deb http://qgis.org/debian trusty main" > /etc/apt/sources.list.d/qgis.list
  apt-get update
  apt-get install qgis python-qgis
```


### Horao

To install horao on Ubuntu Trusty, you have to compile it

```
  sudo apt-get install python-qt4 python-qt4-sql libboost-dev cmake libgdal-dev libpq-dev libopenscenegraph-dev liblwgeom-dev pyqt4-dev-tools libproj-dev libgdal1-dev build-essential

  mkdir build && cd build
  git clone https://github.com/Oslandia/horao.git
  cd horao
  cmake .
  make && sudo make install
  # activate qgis plugins
  mkdir -p ~/.qgis2/python/plugins
  cd ~/.qgis2/python/plugins/
  ln -s ~/build/horao/qgis_plugin
```

### Server-side components

To install all server-side components, we use a Docker container, featuring all necessary bits for this workshop.

Make sure you have Docker installed:

```
  sudo apt-get install docker.io
```

Make a shared local folder:

```
  cd
  mkdir -p data/cache data/restore data/www
  chmod -R 777 data
```

Put the database dump you want to restore in data/restore. See the *data* module to retrieve a database dump.

```
  cp lyon.sql data/restore/
```

Launch the docker daemon in an other terminal:

```
  sudo docker daemon
```

Download and run the container in your Ubuntu OS:

```
  sudo docker run --rm -p 5432:5432 -p 80:80 -v ~/data:/data --name 3dgis_test oslandia/3dgis /sbin/my_init
```

You should now be able to access PostGIS through your localhost Ubuntu (credentials pggis/pggis):

```
  psql -h localhost -U pggis -d pggis
```

And you have access to the web server as well:

* Apache on  [http://localhost](http://localhost)
* Mapcache on [http://localhost/mapcache](http://localhost/mapcache)
* Tinyows on [http://localhost/cgi-bin/tinyows](http://localhost/cgi-bin/tinyows)

You are now ready to follow the workshop.

### Rebuild server-side components

If you have trouble with the Docker container downloaded, or if you want to change the setup, you can rebuild the image yourself. Follow these steps.

```
  git clone https://github.com/vpicavet/docker-pggis.git
  cd docker-pggis
  sudo docker.io build -t oslandia/pggis .
  cd ..
  git clone https://github.com/vpicavet/docker-3dgis.git
  cd docker-3dgis
  sudo docker.io build -t oslandia/3dgis .
```

Then follow the steps from previous chapter (docker.io run).

If running the container gives you an infinit number of "...", then you probably hit the mysterious Docker bug we are investigating on. One workaround to get the container work currently is deleting all Docker images and containers, then rebuilding both docker-pggis and docker-3dgis locally.

## Troubleshooting

If you have trouble with the Docker container, see the previous paragraph, and look at the documentation and issues on GitHub.

You can report issues with this workshop on this GitHub's repository issue tracker.

