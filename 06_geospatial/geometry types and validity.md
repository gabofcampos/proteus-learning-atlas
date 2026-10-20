geospatial vector data represents geographical features using geometries such as points and polygons...

geometry validity determines whether a geometry satisfies the structural rules of its type.
a geometry can be syntactically readable but geometrically invalid (see: [link](https://github.com/gabofcampos/madrid-green-spaces/blob/main/notebooks/m1_data_quality_assessment.ipynb)  )

## common geometry types

- **point:** single location represented by coordinates.
- **linestring:** ordered sequence of connected points.
- **polygon:** area enclosed by one exterior ring and optionally interior rings.
- **multipolygon:** a collection of polygons belonging to one feature.
- **GeometryCollection:** A collection of geometries that may have different types.

### what makes a geometry valid?


## geometry validation with GeoPandas

```python
invalid = gdf[~gdf.geometry.is_valid]

print(f"Invalid geometries: {len(invalid)}")
```

**validity is not the same as completeness, non-emptiness, or suitability for analysis. These should be checked separately.**

## how to repare invalid geometries

***Shapely*** provides `make_valid()` to attempt to repair invalid geometries.

```python
from shapely import make_valid

repaired = invalid.geometry.apply(make_valid)
```

**important:** Repairing a geometry can change its type.
	For example, repairing an invalid multipolygon might produce a GeometryCollection containing polygonal and non-polygonal components.
downstream processing must account for this possibility.

## lessons from Madrid Green Spaces milestone1 [git link](https://github.com/gabofcampos/madrid-green-spaces/blob/main/notebooks/m1_data_quality_assessment.ipynb)

While inspecting OSM park geometries:
- 6,366 park features were loaded.
- 10 geometries were identified as invalid.
- All 10 initially failed the intersection test against the Madrid study area.
- After applying `make_valid()`, 9 became GeometryCollections and 1 remained a MultiPolygon.  

## related
- [[coordinate reference systems (CRS)]]
