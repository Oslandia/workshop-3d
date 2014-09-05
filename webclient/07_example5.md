Example 5
=========

This example allows to display textured 3D data stored in the database.

Texture data
------------

We will first discover how the WFS server returns textured data.

Go to this address in a browser:

[http://localhost/cgi-bin/tinyows?SERVICE=WFS&VERSION=1.0.0&REQUEST=GetFeature&outputFormat=JSON&typeName=tows:textured_citygml&featureId=tows:textured_citygml.1](http://localhost/cgi-bin/tinyows?SERVICE=WFS&VERSION=1.0.0&REQUEST=GetFeature&outputFormat=JSON&typeName=tows:textured_citygml&featureId=tows:textured_citygml.1)

We are requesting the first object of the textured table.
Among the loads of data returned, we can notice a field

    "tex": "(appearance/01_BT_1.jpg,\"{{ ..

This is the filename that will be used to access the texture file.

If your environnement has been correctly setup, we should be able to see this particular texture :
[http://localhost/w/textures/appearance/01_BT_1.jpg](http://localhost/w/textures/appearance/01_BT_1.jpg)

Layer creation
--------------

This type of textured data will be created by a WfsTinLayer object.
To create such an object, we will need to set the URL of a the WFS server with the correct layer name.
We will need as well to set the URL prefix from where texture files can be downloaded.

```Javascript
    var urlTin = baseUrl+"&typeName=tows:textured_citygml";
    // base url where to find textures
    var urlImageBase = "/w/textures/";
    
    var tin = new WfsTinLayer(
        urlTin,
        urlImageBase,
        translation,
        nbDiv,
        terrain
    );
```

