Check the result
----------------

In qgis load N02.tif (located in the "lyon_data" folder) as a raster layer an put it just above the dem layer.

In the 'roofs' layer's properties, in the Style tab click on 'Simple Fill' and then on 'Data defined properties...'. Check Color and enter the expression:

    ''||no2_red||','||no2_green||','||no2_blue||',255'

This will allow you to color roofs based on their NO2 rate. But Horao is not yet able to adapt to such dynamic color properties.