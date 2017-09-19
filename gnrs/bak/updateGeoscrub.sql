-- transfer standard country and stateProvince names to geoscrub
UPDATE geoscrub g JOIN country c
ON g.countryID=c.countryID
SET g.countryStd=c.countryNameStd;

UPDATE geoscrub g JOIN stateProvince p
ON g.stateProvinceID=p.stateProvinceID
SET g.stateProvinceStd=p.stateProvinceNameStd;

-- set isNewWorld flag
UPDATE geoscrub g JOIN newWorldCountries c
ON g.countryID=c.countryID
SET g.isNewWorld=1
WHERE c.isNewWorld=1;

UPDATE geoscrub g JOIN newWorldCountries c
ON g.countryID=c.countryID
SET g.isNewWorld=0
WHERE g.countryID IS NOT NULL and g.isNewWorld IS NULL;
