Example2
========

Code analysis
-------------

In this example, we have access to another set of data with some interesting semantic information.

As you can see in this code snippet, we now use the "roofs" layer that we already used in QGIS.

```Javascript
var tileProvider = new WfsTileProvider(
                       'http://192.168.56.101/cgi-bin/tinyows',
                       'tows:roofs',
                       rectangle, 500, 3);
```

We visualize the NO2 value of each building by changing the coloring function:

```Javascript
tileProvider.setColorFunction(function(properties){
    return new Cesium.Color(properties.no2_red / 255., properties.no2_green / 255., properties.no2_blue / 255.);
});
```

We would like to view the properties of any selected feature. We change the code handling the highlighting of the features:

```Javascript
var print_attributes = function() {
    var properties = restore.primitive.properties[restore.id];
    var string = "<table>";
    for(var p in properties) {
        // filtering properties
        if(p == "gid" || p == "hfacade") {
            string += "<tr> <th>" + p + "</th><th>" + properties[p] + "</th></tr>";
        }
        if(p == "no2_green") {
            var no2 = properties[p];
            no2 = 30 + (no2 - 25) * 10 / 115; // rough approximation
            string += "<tr> <th>NO2</th><th>" + no2.toFixed(2) + "µg.m^-3</th></tr>";
        }
    }
    string += "</table>"
    return string;
}
var entity = new Cesium.Entity({name : 'Attributes'});

...

entity.description = {
    getValue : print_attributes
};
viewer.selectedEntity = entity;
```

The first part of the code defines a function that will build an HTML-formatted string containing the attributes' description. We use this function to filter and format the relevant properties.

The second part of the code assigns this description to a Cesium entity. By setting this entity as the viewer's selected entity, Cesium displays a box with the feature's information.

Exercises
---------
* Change the imagery layer.
* Change the thematic coloring to view in blue the buildings of more than 30 meters and in green the other ones (use the hfacade property).
* Add the color property to the displayed attributes.