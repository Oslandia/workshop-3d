Example 1
=========

HTML UI
-------

The result of the first example can be seen by pointing your browser to the following address :
* [http://localhost/w/cuardo/client.html?examples/example1](http://localhost/w/cuardo/client.html?examples/example1)

It consists in a simple scene with a textured terrain on the city of Lyon.

Basic controls of the camera are obtained by using the mouse :
* Left-click + move : rotation
* Right-click + move : paning (translation)
* Wheel : zooming in/out

The panel on the left gives a list of layers that can be made visible or invisible at the user request.

A feature identification tool is also available (more on this later).

example1.js
------------

Let's now have a look at the scene file that allows to display such a scene.

One of the first important properties of the scene is the extent that we want to be able to visualize.
The first lines of the file allow to define such an extent with it's center and size:

```Javascript
cuardo.translation = new THREE.Vector3(-1844157, -5175124, -150);
var sceneSize = 1500;
```

The 'cuardo.translation' is a 3D vector that is used to center the scene on a particular point. This translation is appliyed to all input data points. In this example, the point (1844157, 5175124, 150) will be a the center of the scene.

Then we need to tell Cuardo to build a terrain out of a WMS service.
Two services will be requested for that: 
* a WMS service that will return a Digital Elevation Model in order to elevate the terrain model 
* a WMS service thta will provide a texture to put on the terrain.

The terrain is created by instanciating a new 'Terrain' object:

```Javascript
var terrain = new cuardo.Terrain(urlDem);
```
An additional parameter can be provided to set the terain mesh resolution (by default tiles are 32x32);

The orthophoto to dispaly on the terrain is créated as a new RasterLayer:

```Javascript
var ortho = new cuardo.RasterLayer(urlTex, terrain);
```

The layers are grouped in a map object that is responsible for creating a viewport (an html canvas) at a specified place in the html document (here the 'container' element). 

```Javascript
var map = new cuardo.Map('container', [terrain, ortho], sceneSize, 0);
```

The last parameter is the number of levels of detail (see bellow), here it's zero.

To be able to move around the scene, we need to react to mouse events. The class GISControls provides predifined interactions:
* Left-click + move : rotation
* Right-click + move : paning (translation)
* Wheel : zooming in/out

```Javascript
// add camera controler
var controls = new cuardo.GISControls(map.camera, null, map.target );
controls.maxDistance = sceneSize * 10;
controls.addEventListener('change', map.requestRender );
```
The 'addEventListener' statement allows the GISControls instance to request a render from the map when the camera position as changed.

To be able to show/hide certain layers, we create a list of labelled checkboxes in the the user menu's element 'layerList' (top left):

```Javascript
// add menu to toggle layer visibility
var layerVisibilityControls = new cuardo.LayerVisibilityControl('layerList', map.requestRender);
layerVisibilityControls.add("Terrain", terrain);
layerVisibilityControls.add("OrthoPhoto", ortho);
```

In the same fashion, we had progress bars that will inform the user of the advancement of the tile generation:

```Javascript
// add progress bar
var progress = new cuardo.ProgressBarControl('progressInfo', notification);
```


Level of details
----------------

Cuardo builds a 3D scene where objects are stored in a quadtree. For each subdivision of the quadtree, a new tile is requested to each "tiler" defined in the scene file. Each tiler can choose to return a more detailed version of its tile based on the size requested. This is the case for the terrain tiler. The smaller the area requested is, the more detailed will be the returned data.

The 'maxLOD' parameter of the scene file allows to set the maximum level of subdivisions of the quadtree. With maxLOD = 0, no subdivision is involved and only a square tile of fixed size is present.

**Exercices**:
* Change the extent
* Move the translation vector a bit
* Try to increase the maxLOD value to 1 and 2 in the script and test the impacts (by reloading client.html). You should see more detailed versions of the satellite view when zooming in.

