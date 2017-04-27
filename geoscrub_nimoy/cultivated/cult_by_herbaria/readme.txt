Flags as cultivated observations within a given radius (currently
3 km) of a herbarium. Main idea is to exclude cultivated specimens
in botanical garden, which are often associated with herbaria.

Sets: 
isCultivated=1
isCultivatedReason=CONCAT(isCultivatedReason," Proximity to herbarium ")

Empirically, 3 km gives good results (high proportion of "true"
positives, few certain false positives). Even though majority of
herbaria are not associated with botanical gardens, they are almost
always in cities, and frequently on university campuses. Nearby 
collections are therefore often cultivated or at least weedy.

If someone were interested in adventive weedy specimens (as opposed
to human planted) this might be an undesirable exclusion criterion.
