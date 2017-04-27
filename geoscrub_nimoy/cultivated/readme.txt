Files in this directory update the isCultivated field
in table geoscrub using a variety of methods:

1. Herbaria (folder: cult_by_herbaria)
Flag as cultivated any specimen within a fixed distance (15 km?) of a herbarium.Assumes that many herbaria are also botanical gardens. Distance calculated using great circle algorithm.

2. Cities (cult_by_city)
Flag as (possibly) cultivated any specimens near cities. Algorithm uses a circle scaled by population size. Distance calculated using great circle algorithm.

3. Taxon-by-region filters (cult_by_taxon)
Flag or unflag as cultivated according to know distributions. For example, no pines in New World south of Nicaragua.

4. Locality (cult_by_locality)
Searches for keywords in locality description which might suggest cultivated specimen (cultivated, cultivado, garden, jardin, etc.).

Scripts in update_view/ transfer final results to viewFullOccurrence
