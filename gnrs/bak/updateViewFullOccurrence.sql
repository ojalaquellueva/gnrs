-- updates viewFullOccurrence directly from geoscrub table

-- plot observations
UPDATE bien2.viewFullOccurrence v JOIN geoscrub g
ON v.DBPlotID=g.sourceID
SET
v.countryStd=g.countryStd,
v.countryError=g.distErrCountry,
v.ProvinceStd=g.stateProvinceStd,
v.ProvinceError=g.distErrStateProvince,
v.isValidLatLong=IF(g.isBadLatLong=0,1,0),
v.isNewWorld=g.isNewWorld,
v.isCultivated=g.isCultivated,
v.isCultivatedReason=g.isCultivatedReason
WHERE g.sourceTable="PlotMetaDataDimension";

-- specimen observations
UPDATE bien2.viewFullOccurrence v JOIN geoscrub g
ON v.ObservationID=g.sourceID
SET
v.countryStd=g.countryStd,
v.countryError=g.distErrCountry,
v.ProvinceStd=g.stateProvinceStd,
v.ProvinceError=g.distErrStateProvince,
v.isValidLatLong=IF(g.isBadLatLong=0,1,0),
v.isNewWorld=g.isNewWorld,
v.isCultivated=g.isCultivated,
v.isCultivatedReason=g.isCultivatedReason
WHERE g.sourceTable="IndividualObservation";