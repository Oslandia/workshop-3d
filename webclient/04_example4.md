Example 4
=========

This example shows how to setup a scene with different levels of detail.

We will build a scene with two different LODs for the buildings layer.
Two WfsLayer objects will then be created for that purpose, each one with the same URL, but with a different symbology.

Let's say we want to display flat polygons most of the time, but extruded polygons when we are looking close at the ground.

The two LODs will be defined this way :

    var roofs = new WfsLayer(
        roofsUrl,
        ...
        [sceneSize/2+1,10000] // <- visibility range
    );

    var extruded = new WfsLayer(
        roofsUrl,
        ...
        [0,sceneSize/2+1] // <- visibility range
    );

Note here the new last parameter that allows to define the visibility range of a layer.

In order to understand what is expected here, some explanations of how LODs are handled by Cardano are needed.
Each level of subdividion will divide one or more tile into four smaller squares.
The subdivision occurs when the camera is approaching the ground.

The very first level (LOD0) is displayed when the camera has a distance to the ground greater than the size of the scene / 2.
The next level (LOD1) is displayed when the camera has a distance to the ground between the size of the scene / 2 and the size of the scene /4 and so on.

So, if you want to define a scene with two LODs, we must use two visibility ranges: one from 0 to sceneSize/2 and one from sceneSize/2 to infinite.
