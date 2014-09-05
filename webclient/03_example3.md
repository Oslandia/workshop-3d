Example 3
=========

The third example exhibits a scene with a terrain layer and some 3D buildings.

These buildings are obtained by extruding the base flat polygons, i.e. creating a volume out of a base plane and an height.

When looking at the source code, the only novelty compared to the previous example is the way the symbology of the roof layer is created:

    var symbology = {
        zOffsetPercent:2e-3, // Z fighting
        zOffset:0.5,
        polygon:
        {
            extrude: { property: "hfacade" },
            color: { expression: buildingClass.toString() }
        }
    };

The color is still given by a Javascript function.

The new property here is the "extrude" property that is used to create an extruded representation of 2D polygons. The input data coming from the database are still the same, 2D polygons, but the client is able to transform them into a volume before displaying them.

Here, "extrude" is defined by means of a property of the current feature: "hfacade". It is direct 1:1 mapping between the value of the field and the height used for the extrusion.

This "extrude" property can be defined by:
* a constant
* a property as depicted here
* an expression

**Exercises**:
* Modify the symbology to set the height to a constant of 10m.
* Modify the symbology to set it to 2 times the value of the property "hfacade"

