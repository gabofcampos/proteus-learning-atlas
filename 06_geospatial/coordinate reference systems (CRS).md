==CRS defines how a 2 dimensional map projects real places on earth.==
the decision of which map projection to pick and which CRS depends on the regional extent of the area of work, the data used and its availability.

### the basic idea
the earth is a 3d spherical (ellipsoidal) object but maps are the 2d representation of said 3d object.
there are different approaches to how to translate an earth's  location in its curved surface to its 2d representation (on paper).

the earth is not flat so trying to represent it in a flat surface always entails some distortion

a CRS bridges the gap between the different dimensional formats using a combination of datum (earth model), map projection and a coordinate grid (ellipsoidal vs geoidal).

## crs = projection + datum + coordinate system 
 - **projection:** how curved earth's coordinates are flattened onto a map (Mercator, UTM, Lambert...)
 - **datum:** the reference model of Earth used for positioning (WGS84, GDA2020...)
 - **coordinate system/vertical reference:** whether height is measured on an ellipsoid (smooth math based surface) or a geoid (models sea level variations)

*from a set of coordinates a CRS will tell GIS how to interpret those numbers*
## types of crs
there are two main types of CRS:
1. **geographic coordinate systems**: use angular units like degrees (*WGS84*)
2. **projected coordinate systems:** they convert the Earth's surface to a flat map using meters or feet (*UTM, MGA...*)