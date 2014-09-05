Example 1
=========

HTML UI
-------

The result of the first example can be seen by pointing your browser to the following address :
* http://localhost/cardano/client.html?examples/example1

It consits of a simple scene with a textured terrain on the city of Lyon.

Basic controls of the camera are obtained by using the mouse :
* Left-click + move : rotation
* Right-click + move : paning (translation)
* Wheel : zooming in/out

The panel on the left gives a list of layers that can be made visible or invisible at the user request.

A feature identification tool is also available (more on this later).

example1.js
------------

Let's now have a look at the scene file that allows to display such a scene.

All scene files must be valid javascript files and must provide a 'getConfig' function.

One of the first important properties of the scene is the extent that we want to be able to visualize.
The first lines of the file allow to define such an extent :

    // small extent
    var extent = [1843456.5,5174649.5,1844858.1,5175600.3];
    
    var width = extent[2]-extent[0];
    var height = extent[3]-extent[1];
    var sceneSize = Math.max(width,height) | 0;
  
The 'sceneSize' variable will be returned by the function.

Then we need to tell Cardano to build a terrain out of a WMS service.
Two services will be requested for that: one WMS service that will return a Digital Elevation Model in order to elevate the terrain model and an optional texture to put on the terrain.

The terrain is created by instanciating a new 'Terrain' object, with the following options :

    var terrain = new Terrain(
        urlDem,   // <- URL of the DEM
        [
            {url:urlTex, name:'Ortho photo'} // <- URL and name of the texture
        ],
        translation,
        nbDiv
    );

* The 'translation' parameter is a 3D vector that is used to center the scene on a particular point.
* 'nbDiv' (32 here) gives the number of subdivisions for each tile of the terrain. It has an impact on the resolution of altitude data.

This object will now be used to define what "layers" will be visible by the final user, displayed within the left panel of the UI. This is what the following lines do:

    var layers = [
        {
            name:'Terrain',
            levels:[terrain]
        }
    ];

Level of details
----------------

TODO
