Flags observations as cultivated observations according to taxon-
specific rules about political divisions where that taxon does or 
does not occur. For example, if genus=Pinus, flag as cultivated
if country not in (Canada, United States, Mexico, Guatemala, 
El Salvador, Honduras, Nicaragua) [etc.].

Obviously only useful for higher taxa with well-known distributions.

Sets: 
isCultivated=1
isCultivatedReason=CONCAT(isCultivatedReason," Outside range of $higerTaxon ")
