-- fixes isCultivated field in table geoscrub by (1) setting NULLs to zero, and 
-- (2) setting isCultivated=0 where only reason is proximity to city

UPDATE geoscrub
SET isCultivated=0,
isCultivatedReason=NULL
WHERE isCultivated IS NULL;

UPDATE geoscrub
SET isCultivated=0,
isCultivatedReason=NULL
WHERE isCultivatedReason="Proximity to city";