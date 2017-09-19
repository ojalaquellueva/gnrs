-- update cultivated or disturbed FIA plots in table geoscrub

UPDATE geoscrub g JOIN bien2.PlotMetaDataDimension p
ON g.sourceID=p.DBPlotID
SET 
g.isCultivated=1,
g.isCultivatedReason='FIA disturbed'
WHERE g.sourceTable='PlotMetaDataDimension'
AND p.DBSourceName='FIA' 
AND (g.isCultivated is NULL or g.isCultivated=0);

UPDATE geoscrub g JOIN bien2.PlotMetaDataDimension p JOIN FIA_COND f
ON g.sourceID=p.DBPlotID and p.PlotCD=f.PLT_CN
SET 
g.isCultivated=0,
g.isCultivatedReason=NULL
WHERE g.sourceTable='PlotMetaDataDimension'
AND p.DBSourceName='FIA' 
AND	f.oldgrowth=1 
AND g.isCultivatedReason='FIA disturbed';