Cesium Buildings
================

Code analysis
-------------

The file is located at ~/data/www/cesium-buildings/Example.html. The analysis starts at line 52.

The first 20 lines are basic Cesium configuration.

* We start by instantiating the Cesium viewer and setting a few options for compatibility and optimization.

```Javascript
var viewer = new Cesium.Viewer('cesiumContainer', {baseLayerPicker : false, scene3DOnly : true});
viewer.scene.globe.depthTestAgainstTerrain = true;
```

* We add a terrain provider to the viewer. In this example, we use the standard cesium terrain provider. 

```Javascript
var cesiumTerrainProviderMeshes = new Cesium.CesiumTerrainProvider({
    url : '//cesiumjs.org/stk-terrain/tilesets/world/tiles'
});
viewer.terrainProvider = cesiumTerrainProviderMeshes;
```

* We add an imagery layer. We use an open WMS stream provided by the city of Lyon. We disable the pick feature since this specific WMS provider has no picking information.

```Javascript
var provider = new Cesium.WebMapServiceImageryProvider({
    enablePickFeatures : false,
    url: 'https://download.data.grandlyon.com/wms/grandlyon',
    layers : 'PlanGuide_VueEnsemble_625cm_CC46'//'Ortho2009_vue_ensemble_16cm_CC46'
});
viewer.imageryLayers.addImageryProvider(provider);
```
* We place the camera at the desired position.

```Javascript
var cameraView = new Cesium.Rectangle.fromDegrees(4.848, 45.755, 4.852, 45.76);
viewer.camera.viewRectangle(cameraView);
viewer.camera.lookUp(0.5);
```

Now starts the configuration of Cesium Buildings.

We create our WFS provider. This is the provider in charge of retrieving the 3D geometries from our WFS server.

We pass him the following arguments:
* The url of the WFS server
* The layer of the relevant data
* The extent of the city
* The tile size
* An integer that defines the distance from which the geometries are 

Most of the time, you will not need to change the two last parameters. However, loweringing the view distance can be useful on low-end devices.

```Javascript
var rectangle = Cesium.Rectangle.fromDegrees(4.770386,45.716615,4.899764,45.789917);
var tileProvider = new WfsTileProvider(
                       'http://192.168.56.101/cgi-bin/tinyows',
                       'tows:citygml',
                       rectangle, 500, 3);
viewer.scene.primitives.add(new Cesium.QuadtreePrimitive({tileProvider : tileProvider}));
```

(From this point onwards, only the relevant code will be commented. Toggling mechanisms will be omitted for brievity's and simplicity's sake)

The next block allows the use of thematic coloring .

We can use the WFS tile provider's setColorFunction function to change the way each feature is colored.

The function expects a single argument: a function returning a Cesium Color.

Since the data set we use in this example has very few semantic information, we will just color the features depending on their gid. We will see far more interesting applications in the next example.

```Javascript
tileProvider.setColorFunction(function(properties){
    return properties.gid % 2 ? new Cesium.Color(0.5,0.5,0,1.0) : new Cesium.Color(0,0.5,0.5,1.0);
});
```

We can also easly switch the imagery of the terrain using cesium's base functionnalities:

```Javascript
viewer.scene.imageryLayers.addImageryProvider(
    new Cesium.OpenStreetMapImageryProvider({
      url : '//a.tile.openstreetmap.org/'
}));
```

Finally, we allow highlighting of hovered objects.

We create a handler to record the user's interatcion:

```Javascript
handler = new Cesium.ScreenSpaceEventHandler(viewer.scene.canvas);
handler.setInputAction(function(movement) { ... });
```

We retrieve the picked primitive:

```Javascript
var pickedObject = viewer.scene.pick(movement.endPosition);
```

However, a primitive is a group of features. Cesium gives us the feature's id so we can retrieve a specific feature's attribute:

```Javascript
var attributes = pickedObject.primitive.getGeometryInstanceAttributes(pickedObject.id) ;
```

We can access and change the color of the feature:

```Javascript
attributes.color = Cesium.ColorGeometryInstanceAttribute.toValue(new Cesium.Color(1., 1., 0.));
```