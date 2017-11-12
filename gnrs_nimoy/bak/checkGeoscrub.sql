-- count status of flags in table geoscrub, and compare to viewFullOccurrence

SELECT isCultivated, COUNT(*)
FROM geoscrub
GROUP BY isCultivated;

SELECT isCultivated, isCultivatedReason, COUNT(*)
FROM geoscrub
GROUP BY isCultivated, isCultivatedReason;

SELECT isBadLatLong, count(*)
FROM geoscrub.geoscrub
GROUP BY isBadLatLong;

SELECT isValidLatLong, count(*)
FROM bien2.viewFullOccurrence
GROUP BY isValidLatLong;

SELECT countryVerbatim, countryID, isInCountry, distErrCountry,
latitudeDecimalVerbatim, longitudeDecimalVerbatim
FROM geoscrub
WHERE isBadLatLong=1
LIMIT 25;

