Getting the data
================

Direct download
---------------

You can download archives of all required data here :
http://91.121.102.10/3ddata/

In the "oslandia" directory, you will find some additional data, which we can use later :
* A fixed and cropped Textured 3D dataset, originally from Grand Lyon. We had to manually correct some features, reduce the texture sizes, and we cropped it to our local zone of interest.
* A MapCache cache content, which you can download and install in the *~/data/cache* directory, so as not to suffer from the Grand Lyon server lag.

```
wget http://91.121.102.10/3ddata/Carte_agglo_Lyon_NO2_2012.zip
wget http://91.121.102.10/3ddata/MNT2009_Altitude_10m_CC46.zip
wget http://91.121.102.10/3ddata/fpc_fond_plan_communaut.fpctoit.zip
wget http://91.121.102.10/3ddata/resultat-adr_voie_lieu.adrarrond.zip
wget http://91.121.102.10/3ddata/resultat-jcd_jcdecaux.jcdvelov.zip
wget http://91.121.102.10/3ddata/rhone-alpes-latest.shp.zip
http://91.121.102.10/3ddata/oslandia/lyon3_citygml_small.zip
```

From source
-----------

You can also download the data directly from the source. We only use OpenData, so there is no restriction on usage.

From Lyon Open Data website.

* Arrondissements
([zip file](http://smartdata.grandlyon.com/smartdata/wp-content/plugins/wp-smartdata/proxy.php?format=Shape-zip&name=adr_voie_lieu.adrarrond&commune=&href=https%3A%2F%2Fdownload.data.grandlyon.com%2Fwfs%2Fgrandlyon%3FSERVICE%3DWFS%26REQUEST%3DGetFeature%26typename%3Dadr_voie_lieu.adrarrond%26outputformat%3DSHAPEZIP%26VERSION%3D2.0.0%26SRSNAME%3DEPSG%3A3946))

* Velov Stations 
([zip file](http://smartdata.grandlyon.com/smartdata/wp-content/plugins/wp-smartdata/proxy.php?format=Shape-zip&name=jcd_jcdecaux.jcdvelov&commune=&href=https%3A%2F%2Fdownload.data.grandlyon.com%2Fwfs%2Fsmartdata%3FSERVICE%3DWFS%26REQUEST%3DGetFeature%26typename%3Djcd_jcdecaux.jcdvelov%26outputformat%3DSHAPEZIP%26VERSION%3D2.0.0%26SRSNAME%3DEPSG%3A3946))

* Roofs 
([zip file](http://smartdata.grandlyon.com/smartdata/wp-content/plugins/wp-smartdata/proxy.php?format=shape&name=fpc_fond_plan_communaut.fpctoit.zip&commune=undefined&href=https%3A%2F%2Fdownload.data.grandlyon.com%2Ffiles%2Fgrandlyon%2Flocalisation%2Ffpc_fond_plan_communaut.fpctoit.zip))

* [NO2 estimation](http://smartdata.grandlyon.com/environnement/estimation-de-la-concentration-du-dioxyde-dazote-no2-du-grand-lyon-en-2012) 
([zip file](http://smartdata.grandlyon.com/smartdata/wp-content/plugins/wp-smartdata/proxy.php?format=zip&name=Carte_agglo_Lyon_NO2_2012.zip&commune=undefined&href=https%3A%2F%2Fdownload.data.grandlyon.com%2Ffiles%2Fsmartdata%2Fair_rhonealpes%2FCarte_agglo_Lyon_NO2_2012.zip))

* [Terrain data](http://smartdata.grandlyon.com/imagerie/modfle-numfrique-de-terrain-du-grand-lyon-pixel-de-10-m/)
([zip file](http://smartdata.grandlyon.com/smartdata/wp-content/plugins/wp-smartdata/proxy.php?format=zip&name=MNT2009_Altitude_10m_CC46.zip&commune=undefined&href=https%3A%2F%2Fdownload.data.grandlyon.com%2Ffiles%2Fgrandlyon%2Fimagerie%2Fmnt2009%2FMNT2009_Altitude_10m_CC46.zip))

* [Textured 3D data](http://smartdata.grandlyon.com/localisation/maquette-3d-texturfe-du-3f-arrondissement-de-lyon/) ([Zip file - 390bd21e9c0a3adba7677a35aac394e9](http://smartdata.grandlyon.com/smartdata/wp-content/plugins/wp-smartdata/proxy.php?format=CityGML&name=LYON3_CityGML&commune=undefined&href=https%3A%2F%2Fdownload.data.grandlyon.com%2Ffiles%2Fgrandlyon%2Flocalisation%2Fbati3d%2FLYON3_CityGML.zip)) : This is the full original dataset, with high definition textures and some invalid features. We will use our fixed and cropped dataset instead. Feel free to use this anyway if you feel adventurous :-)

From OpenStreetMap (Geofabrik exports)

* Parcs and forest 
([zip file](http://download.geofabrik.de/europe/france/rhone-alpes-latest.shp.zip))


<!---
# fast forward :)
grep 'zip file' 01_get_data.md |sed 's/(\[zip file\](\(.*\)))/wget "\1" -O out.zip \&\& unzip out.zip/' | sh
-->
