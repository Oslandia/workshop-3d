Example 2
=========

Data
----

With this example, we are going to add some 2D vector data to our previous simple scene.

To add vector data, we must create a vector tiling object, instance of a class named "WfsLayer" because that will be requested from a WFS server (TinyOWS here). In the code, the following lines will define this new layer :

```Javascript
    var baseUrl = "/cgi-bin/tinyows?SERVICE=WFS&VERSION=1.0.0&REQUEST=GetFeature&outputFormat=JSON";
    var roofsUrl = baseUrl+"&typeName=tows:roofs";
    ...
    
    var roofs = new WfsLayer(
        roofsUrl,
        terrain, // <- reference to the terrain layer (for elevation)
        symbology
    );
```

The parameters involved are very close to the ones we have been using for the Terrain layer. We are here getting data from a WFS server that is able to serve data formatted in JSON.

Symbology
---------

We need to tell Cuardo how to display vector features. This is what is called symbology in usual GIS applications.

Cuardo supports a simple symbology defined by means of Javascript objects.

One of the most simple symbology is a simple opaque fill of each polygon feature.

```Javascript
    var symbology = {
        zOffsetPercent:2e-3, // Z fighting
        zOffset:0.5,
        polygon:
        {
            color: 0x0000ff // <- blue
        }
    };
```

zOffset* parameters are specific to the 3D case where different layers of flat polygons could be stacked on the ground. zOffset properties allow to separate each layers by a small artifical elevation in order for them not to mix and give bad visual artefacts.

To trace contours of each polygon, with a given color and width, replace the symbology with:

```Javascript
    var symbology = {
        zOffsetPercent:2e-3, // Z fighting
        zOffset:0.5,
        polygon:
        {
            color: 0x0000ff, // <- blue
            lineColor: 0x000000, // <- black
            lineWidth: 3
        }
    };
```

The third example of symbology introduces an expression-based symbology. It allows for instance to define thematic analysis. It must be defined as a Javascript function that will be evaluated for each vector feature.
The function must take one parameter that will represents properties (fields in the table) of the current feature.

The function will return a color, based on the value of the property "hfacade" of the current feature.

```Javascript
    var buildingClass = function (prop) {
        var categories = [{min: 2.0,  max: 2.74, color:0xffffff},
                          {min: 2.74, max: 4.27, color:0xafd1e7},
                          {min: 4.27, max: 20.74, color:0x3d8dc3},
                          {min: 20.74, max: 200,  color:0x08306b}];
        for ( var i = 0; i < categories.length; i++ ) {
            var klass = categories[i];
            if ( (prop.hfacade >= klass.min) && (prop.hfacade < klass.max) ) {
                return klass.color;
            }
        }
        return 0x000000;
    }
```

Please be aware that an expression-based symbology must be passed as a string. This is why we use the method toString() to convert the function into a string.

```Javascript
    var symbology = {
        zOffsetPercent:2e-3, // Z fighting
        zOffset:0.5,
        polygon:
        {
            color: { expression: buildingClass.toString() },
            lineColor: 0x000000,
            lineWidth: 3
        }
    };
```

**Exercises**:
* Try to change the symbology used by the vector layer.
* Test different values of the properties (color, lineWidth, lineColor, etc.)
* The roofs layer contains three other fields, named 'no2_red', 'no2_green' and 'no2_blue'. Define a symbology that will use these fields to make a color.
