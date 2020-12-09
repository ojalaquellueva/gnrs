-- ------------------------------------------------------------------
-- Adds & populates column county_parish_std in table county_parish 
-- Contains plain ascii names minus any category modifiers
-- ------------------------------------------------------------------

--
-- Table: county_parish
--

ALTER TABLE county_parish
ADD COLUMN county_parish_std VARCHAR(100) DEFAULT NULL
;
UPDATE county_parish
SET county_parish_std=county_parish_ascii
;

-- Prefixes including article 'de', 'of', etc.
UPDATE county_parish
SET county_parish_std=
CASE
WHEN county_parish_std ILIKE 'Arrondissement des%' THEN regexp_replace(county_parish_std, 'Arrondissement des', '', 'i')
WHEN county_parish_std ILIKE 'Arrondissement de%' THEN regexp_replace(county_parish_std, 'Arrondissement de', '', 'i')
WHEN county_parish_std ILIKE 'Arrondissement du%' THEN regexp_replace(county_parish_std, 'Arrondissement du', '', 'i')
WHEN county_parish_std ILIKE 'Borough of %' THEN regexp_replace(county_parish_std, 'Borough of ', '', 'i')
WHEN county_parish_std ILIKE 'Canton de%' THEN regexp_replace(county_parish_std, 'Canton de', '', 'i')
WHEN county_parish_std ILIKE 'Castello di%' THEN regexp_replace(county_parish_std, 'Castello di', '', 'i')
WHEN county_parish_std ILIKE 'Commune de%' THEN regexp_replace(county_parish_std, 'Commune de', '', 'i')
WHEN county_parish_std ILIKE 'Concelho do%' THEN regexp_replace(county_parish_std, 'Concelho do', '', 'i')
WHEN county_parish_std ILIKE 'Concelho da%' THEN regexp_replace(county_parish_std, 'Concelho da', '', 'i')
WHEN county_parish_std ILIKE 'Concelho de%' THEN regexp_replace(county_parish_std, 'Concelho de', '', 'i')
WHEN county_parish_std ILIKE 'Circunscricao da %' THEN regexp_replace(county_parish_std, 'Circunscricao da ', '', 'i')
WHEN county_parish_std ILIKE 'Circunscricao de %' THEN regexp_replace(county_parish_std, 'Circunscricao de ', '', 'i')
WHEN county_parish_std ILIKE 'Circunscricao do %' THEN regexp_replace(county_parish_std, 'Circunscricao do ', '', 'i')
WHEN county_parish_std ILIKE 'City and Borough of %' THEN regexp_replace(county_parish_std, 'City and Borough of ', '', 'i')
WHEN county_parish_std ILIKE 'City and County of%' THEN regexp_replace(county_parish_std, 'City and County of', '', 'i')
WHEN county_parish_std ILIKE 'City of%' THEN regexp_replace(county_parish_std, 'City of', '', 'i')
WHEN county_parish_std ILIKE 'Commune of%' THEN regexp_replace(county_parish_std, 'Commune of', '', 'i')
WHEN county_parish_std ILIKE 'Delegation de %' THEN regexp_replace(county_parish_std, 'Delegation de ', '', 'i')
WHEN county_parish_std ILIKE 'Delegation d''%' THEN regexp_replace(county_parish_std, 'Delegation d''', '', 'i')
WHEN county_parish_std ILIKE 'Departement des %' THEN regexp_replace(county_parish_std, 'Departement des ', '', 'i')
WHEN county_parish_std ILIKE 'Departement du %' THEN regexp_replace(county_parish_std, 'Departement du ', '', 'i')
WHEN county_parish_std ILIKE 'Departement d''' THEN regexp_replace(county_parish_std, 'Departement d''', '', 'i')
WHEN county_parish_std ILIKE 'Departement de la %' THEN regexp_replace(county_parish_std, 'Departement de la ', '', 'i')
WHEN county_parish_std ILIKE 'Departement de l''%' THEN regexp_replace(county_parish_std, 'Departement de l''', '', 'i')
WHEN county_parish_std ILIKE 'Departamento del%' THEN regexp_replace(county_parish_std, 'Departamento del', '', 'i')
WHEN county_parish_std ILIKE 'Departamento de%' THEN regexp_replace(county_parish_std, 'Departamento de', '', 'i')
WHEN county_parish_std ILIKE 'Departament of%' THEN regexp_replace(county_parish_std, 'Departament of', '', 'i')
WHEN county_parish_std ILIKE 'Departement de%' THEN regexp_replace(county_parish_std, 'Departement de', '', 'i')
WHEN county_parish_std ILIKE 'Distrito del%' THEN regexp_replace(county_parish_std, 'Distrito del', '', 'i')
WHEN county_parish_std ILIKE 'Distrito da%' THEN regexp_replace(county_parish_std, 'Distrito da', '', 'i')
WHEN county_parish_std ILIKE 'Distrito do%' THEN regexp_replace(county_parish_std, 'Distrito do', '', 'i')
WHEN county_parish_std ILIKE 'Distrito de%' THEN regexp_replace(county_parish_std, 'Distrito de', '', 'i')
WHEN county_parish_std ILIKE 'Estado de%' THEN regexp_replace(county_parish_std, 'Estado de', '', 'i')
WHEN county_parish_std ILIKE 'Gouvernorat de%' THEN regexp_replace(county_parish_std, 'Gouvernorat de', '', 'i')
WHEN county_parish_std ILIKE 'Heroica Ciudad de %' THEN regexp_replace(county_parish_std, 'Heroica Ciudad de ', '', 'i')
WHEN county_parish_std ILIKE 'Heroica Villa de %' THEN regexp_replace(county_parish_std, 'Heroica Villa de ', '', 'i')
WHEN county_parish_std ILIKE 'Heroica Villa %' THEN regexp_replace(county_parish_std, 'Heroica Villa ', '', 'i')
WHEN county_parish_std ILIKE 'Komuna e %' THEN regexp_replace(county_parish_std, 'Komuna e ', '', 'i')
WHEN county_parish_std ILIKE 'Municipio Autonomo %' THEN regexp_replace(county_parish_std, 'Municipio Autonomo ', '', 'i')
WHEN county_parish_std ILIKE 'Municipio de%' THEN regexp_replace(county_parish_std, 'Municipio de', '', 'i')
WHEN county_parish_std ILIKE 'Municipio Especial%' THEN regexp_replace(county_parish_std, 'Municipio Especial', '', 'i')
WHEN county_parish_std ILIKE 'Parish of%' THEN regexp_replace(county_parish_std, 'Parish of', '', 'i')
WHEN county_parish_std ILIKE 'Partido de %' THEN regexp_replace(county_parish_std, 'Partido de ', '', 'i')
WHEN county_parish_std ILIKE 'Prefecture de la%' THEN regexp_replace(county_parish_std, 'Prefecture de la', '', 'i')
WHEN county_parish_std ILIKE 'Prefecture de%' THEN regexp_replace(county_parish_std, 'Prefecture de', '', 'i')
WHEN county_parish_std ILIKE 'Principality of%' THEN regexp_replace(county_parish_std, 'Principality of', '', 'i')
WHEN county_parish_std ILIKE 'Province of%' THEN regexp_replace(county_parish_std, 'Province of', '', 'i')
WHEN county_parish_std ILIKE 'Provincia del%' THEN regexp_replace(county_parish_std, 'Provincia del', '', 'i')
WHEN county_parish_std ILIKE 'Provincia de%' THEN regexp_replace(county_parish_std, 'Provincia de', '', 'i')
WHEN county_parish_std ILIKE 'Province du%' THEN regexp_replace(county_parish_std, 'Province du', '', 'i')
WHEN county_parish_std ILIKE 'Province de%' THEN regexp_replace(county_parish_std, 'Province de', '', 'i')
WHEN county_parish_std ILIKE 'Qada'' al %' THEN regexp_replace(county_parish_std, 'Qada'' al ', '', 'i')
WHEN county_parish_std ILIKE 'Qada'' ar %' THEN regexp_replace(county_parish_std, 'Qada'' ar ', '', 'i')
WHEN county_parish_std ILIKE 'Qada'' as %' THEN regexp_replace(county_parish_std, 'Qada'' as ', '', 'i')
WHEN county_parish_std ILIKE 'Qada'' at %' THEN regexp_replace(county_parish_std, 'Qada'' at ', '', 'i')
WHEN county_parish_std ILIKE 'Qada'' `%' THEN regexp_replace(county_parish_std, 'Qada'' `', '', 'i')
WHEN county_parish_std ILIKE 'Regional District of %' THEN regexp_replace(county_parish_std, 'Regional District of ', '', 'i')
WHEN county_parish_std ILIKE 'Qarku i%' THEN regexp_replace(county_parish_std, 'Qarku i', '', 'i')
WHEN county_parish_std ILIKE 'Region del%' THEN regexp_replace(county_parish_std, 'Region del', '', 'i')
WHEN county_parish_std ILIKE 'Region du %' THEN regexp_replace(county_parish_std, 'Region du ', '', 'i')
WHEN county_parish_std ILIKE 'Region de %' THEN regexp_replace(county_parish_std, 'Region de ', '', 'i')
WHEN county_parish_std ILIKE 'San Agustin del %' THEN regexp_replace(county_parish_std, 'San Agustin del ', '', 'i')
WHEN county_parish_std ILIKE 'San Agustin de %' THEN regexp_replace(county_parish_std, 'San Agustin de ', '', 'i')
WHEN county_parish_std ILIKE 'San Agustin %' THEN regexp_replace(county_parish_std, 'San Agustin ', '', 'i')
WHEN county_parish_std ILIKE 'San Andres del %' THEN regexp_replace(county_parish_std, 'San Andres del ', '', 'i')
WHEN county_parish_std ILIKE 'San Andres de %' THEN regexp_replace(county_parish_std, 'San Andres  ', '', 'i')
WHEN county_parish_std ILIKE 'San Andres %' THEN regexp_replace(county_parish_std, 'San Andres ', '', 'i')
WHEN county_parish_std ILIKE 'San Antonino del %' THEN regexp_replace(county_parish_std, 'San Antonino del ', '', 'i')
WHEN county_parish_std ILIKE 'San Antonino de %' THEN regexp_replace(county_parish_std, 'San Antonino ', '', 'i')
WHEN county_parish_std ILIKE 'San Antonino %' THEN regexp_replace(county_parish_std, 'xxx', '', 'i')
WHEN county_parish_std ILIKE 'San Antonino %' THEN regexp_replace(county_parish_std, 'San Antonino ', '', 'i')
WHEN county_parish_std ILIKE 'San Baltazar %' THEN regexp_replace(county_parish_std, 'San Baltazar ', '', 'i')
WHEN county_parish_std ILIKE 'San Bartolo %' THEN regexp_replace(county_parish_std, 'San Bartolo ', '', 'i')
WHEN county_parish_std ILIKE 'San Bartolome %' THEN regexp_replace(county_parish_std, 'San Bartolome ', '', 'i')
WHEN county_parish_std ILIKE 'San Carlos Yautepec%' THEN regexp_replace(county_parish_std, 'Yautepec', '', 'i')
WHEN county_parish_std ILIKE 'San Cristobal de %' THEN regexp_replace(county_parish_std, 'San Cristobal de ', '', 'i')
WHEN county_parish_std ILIKE 'San Damian %' THEN regexp_replace(county_parish_std, 'San Damian ', '', 'i')
WHEN county_parish_std ILIKE 'San Diego la Mesa %' THEN regexp_replace(county_parish_std, 'San Diego la Mesa ', '', 'i')
WHEN county_parish_std ILIKE 'San Diego de %' THEN regexp_replace(county_parish_std, 'San Diego de ', '', 'i')
WHEN county_parish_std ILIKE 'San Diego %' THEN regexp_replace(county_parish_std, 'San Diego ', '', 'i')
WHEN county_parish_std ILIKE 'San Dionisio del %' THEN regexp_replace(county_parish_std, 'San Dionisio del ', '', 'i')
WHEN county_parish_std ILIKE 'San Dionisio %' THEN regexp_replace(county_parish_std, 'San Dionisio ', '', 'i')
WHEN county_parish_std ILIKE 'San Felipe del %' THEN regexp_replace(county_parish_std, 'San Felipe del ', '', 'i')
WHEN county_parish_std ILIKE 'San Felipe de %' THEN regexp_replace(county_parish_std, 'San Felipe de ', '', 'i')
WHEN county_parish_std ILIKE 'San Felipe %' THEN regexp_replace(county_parish_std, 'San Felipe ', '', 'i')
WHEN county_parish_std ILIKE 'San Francisco del %' THEN regexp_replace(county_parish_std, 'San Francisco del ', '', 'i')
WHEN county_parish_std ILIKE 'San Francisco de %' THEN regexp_replace(county_parish_std, 'San Francisco de ', '', 'i')
WHEN county_parish_std ILIKE 'San Francisco %' THEN regexp_replace(county_parish_std, 'San Francisco ', '', 'i')
WHEN county_parish_std ILIKE 'San Gabriel %' THEN regexp_replace(county_parish_std, 'San Gabriel ', '', 'i')
WHEN county_parish_std ILIKE 'San Gregorio De %' THEN regexp_replace(county_parish_std, 'San Gregorio De ', '', 'i')
WHEN county_parish_std ILIKE 'San Gregorio %' THEN regexp_replace(county_parish_std, 'San Gregorio ', '', 'i')
WHEN county_parish_std ILIKE 'San Ignacio de %' THEN regexp_replace(county_parish_std, 'San Ignacio de ', '', 'i')
WHEN county_parish_std ILIKE 'San Ignacio %' THEN regexp_replace(county_parish_std, 'San Ignacio ', '', 'i')
WHEN county_parish_std ILIKE 'San Ildefonso %' THEN regexp_replace(county_parish_std, 'San Ildefonso ', '', 'i')
WHEN county_parish_std ILIKE 'San Isidro %' THEN regexp_replace(county_parish_std, 'San Isidro ', '', 'i')
WHEN county_parish_std ILIKE 'San Jeronimo %' THEN regexp_replace(county_parish_std, 'San Jeronimo ', '', 'i')
WHEN county_parish_std ILIKE 'San Jose del %' THEN regexp_replace(county_parish_std, 'San Jose del ', '', 'i')
WHEN county_parish_std ILIKE 'San Jose de %' THEN regexp_replace(county_parish_std, 'San Jose de ', '', 'i')
WHEN county_parish_std ILIKE 'San Jose %' THEN regexp_replace(county_parish_std, 'San Jose ', '', 'i')
WHEN county_parish_std ILIKE 'San Juan Bautista %' THEN regexp_replace(county_parish_std, 'San Juan Bautista ', '', 'i')
WHEN county_parish_std ILIKE 'San Juan del %' THEN regexp_replace(county_parish_std, 'San Juan del ', '', 'i')
WHEN county_parish_std ILIKE 'San Juan de %' THEN regexp_replace(county_parish_std, 'San Juan de ', '', 'i')
WHEN county_parish_std ILIKE 'San Juan %' THEN regexp_replace(county_parish_std, 'San Juan ', '', 'i')
WHEN county_parish_std ILIKE 'San Lorenzo %' THEN regexp_replace(county_parish_std, 'San Lorenzo ', '', 'i')
WHEN county_parish_std ILIKE 'San Lucas %' THEN regexp_replace(county_parish_std, 'San Lucas ', '', 'i')
WHEN county_parish_std ILIKE 'San Luis del %' THEN regexp_replace(county_parish_std, 'San Luis del ', '', 'i')
WHEN county_parish_std ILIKE 'San Luis de %' THEN regexp_replace(county_parish_std, 'San Luis de ', '', 'i')
WHEN county_parish_std ILIKE 'San Luis %' THEN regexp_replace(county_parish_std, 'San Luis ', '', 'i')
WHEN county_parish_std ILIKE 'San Manuel de %' THEN regexp_replace(county_parish_std, 'San Manuel de ', '', 'i')
WHEN county_parish_std ILIKE 'San Manuel %' THEN regexp_replace(county_parish_std, 'San Manuel ', '', 'i')
WHEN county_parish_std ILIKE 'San Marcial %' THEN regexp_replace(county_parish_std, 'San Marcial ', '', 'i')
WHEN county_parish_std ILIKE 'San Martin de %' THEN regexp_replace(county_parish_std, 'San Martin de ', '', 'i')
WHEN county_parish_std ILIKE 'San Martin ' THEN regexp_replace(county_parish_std, 'San Martin ', '', 'i')
WHEN county_parish_std ILIKE 'San Mateo del %' THEN regexp_replace(county_parish_std, 'San Mateo del ', '', 'i')
WHEN county_parish_std ILIKE 'San Mateo de %' THEN regexp_replace(county_parish_std, 'San Mateo de ', '', 'i')
WHEN county_parish_std ILIKE 'San Mateo %' THEN regexp_replace(county_parish_std, 'San Mateo ', '', 'i')
WHEN county_parish_std ILIKE 'San Matias %' THEN regexp_replace(county_parish_std, 'San Matias ', '', 'i')
WHEN county_parish_std ILIKE 'San Melchor %' THEN regexp_replace(county_parish_std, 'San Melchor ', '', 'i')
WHEN county_parish_std ILIKE 'xxSan Miguel del x%' THEN regexp_replace(county_parish_std, 'San Miguel del ', '', 'i')
WHEN county_parish_std ILIKE 'San Miguel de %' THEN regexp_replace(county_parish_std, 'San Miguel de ', '', 'i')
WHEN county_parish_std ILIKE 'San Miguel %' THEN regexp_replace(county_parish_std, 'San Miguel ', '', 'i')
WHEN county_parish_std ILIKE 'San Nicolas de %' THEN regexp_replace(county_parish_std, 'San Nicolas de ', '', 'i')
WHEN county_parish_std ILIKE 'San Nicolas %' THEN regexp_replace(county_parish_std, 'San Nicolas ', '', 'i')
WHEN county_parish_std ILIKE 'San Pablo del %' THEN regexp_replace(county_parish_std, 'San Pablo del ', '', 'i')
WHEN county_parish_std ILIKE 'San Pablo de %' THEN regexp_replace(county_parish_std, 'San Pablo de ', '', 'i')
WHEN county_parish_std ILIKE 'San Pablo %' THEN regexp_replace(county_parish_std, 'San Pablo ', '', 'i')
WHEN county_parish_std ILIKE 'San Patricio %' THEN regexp_replace(county_parish_std, 'San Patricio ', '', 'i')
WHEN county_parish_std ILIKE 'San Pedro del %' THEN regexp_replace(county_parish_std, 'San Pedro del ', '', 'i')
WHEN county_parish_std ILIKE 'San Pedro de %' THEN regexp_replace(county_parish_std, 'San Pedro de ', '', 'i')
WHEN county_parish_std ILIKE 'San Pedro %' THEN regexp_replace(county_parish_std, 'San Pedro ', '', 'i')
WHEN county_parish_std ILIKE 'San Pedro y San Pablo %' THEN regexp_replace(county_parish_std, 'San Pedro y San Pablo ', '', 'i')
WHEN county_parish_std ILIKE 'San Rafael del %' THEN regexp_replace(county_parish_std, 'San Rafael del ', '', 'i')
WHEN county_parish_std ILIKE 'San Raymundo %' THEN regexp_replace(county_parish_std, 'San Raymundo ', '', 'i')
WHEN county_parish_std ILIKE 'San Salvador %' THEN regexp_replace(county_parish_std, 'San Salvador ', '', 'i')
WHEN county_parish_std ILIKE 'San Sebastian de %' THEN regexp_replace(county_parish_std, 'San Sebastian de ', '', 'i')
WHEN county_parish_std ILIKE 'San Sebastian %' THEN regexp_replace(county_parish_std, 'San Sebastian ', '', 'i')
WHEN county_parish_std ILIKE 'San Simon de %' THEN regexp_replace(county_parish_std, 'San Simon de ', '', 'i')
WHEN county_parish_std ILIKE 'San Simon %' THEN regexp_replace(county_parish_std, 'San Simon ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Ana de %' THEN regexp_replace(county_parish_std, 'Santa Ana de ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Ana %' THEN regexp_replace(county_parish_std, 'Santa Ana ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Apolonia %' THEN regexp_replace(county_parish_std, 'Santa Apolonia ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Barbara de %' THEN regexp_replace(county_parish_std, 'Santa Barbara de ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Barbara Do %' THEN regexp_replace(county_parish_std, 'xxx', '', 'i')
WHEN county_parish_std ILIKE 'Santa Barbara Do %' THEN regexp_replace(county_parish_std, 'xxx', '', 'i')
WHEN county_parish_std ILIKE 'Santa Catalina %' THEN regexp_replace(county_parish_std, 'Santa Catalina ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Catarina %' THEN regexp_replace(county_parish_std, 'Santa Catarina ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Cruz Da %' THEN regexp_replace(county_parish_std, 'Santa Cruz Da ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Cruz Das %' THEN regexp_replace(county_parish_std, 'Santa Cruz Das ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Cruz de %' THEN regexp_replace(county_parish_std, 'Santa Cruz de ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Cruz %' THEN regexp_replace(county_parish_std, 'Santa Cruz ', '', 'i')
WHEN county_parish_std ILIKE 'Santafe de Antioquia%' THEN regexp_replace(county_parish_std, 'Santafe de ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Fe De %' THEN regexp_replace(county_parish_std, 'Santa Fe De ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Fe Do %' THEN regexp_replace(county_parish_std, 'Santa Fe Do ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Fe %' THEN regexp_replace(county_parish_std, 'Santa Fe ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Filomena Do %' THEN regexp_replace(county_parish_std, 'Santa Filomena Do ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Helena De %' THEN regexp_replace(county_parish_std, 'Santa Helena De ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Ines de %' THEN regexp_replace(county_parish_std, 'Santa Ines de ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Ines %' THEN regexp_replace(county_parish_std, 'Santa Ines ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Isabel Do %' THEN regexp_replace(county_parish_std, 'Santa Isabel Do ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Isabel %' THEN regexp_replace(county_parish_std, 'Santa Isabel ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Lucia %' THEN regexp_replace(county_parish_std, 'Santa Lucia ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Luzia do %' THEN regexp_replace(county_parish_std, 'Santa Luzia do ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Luzia %' THEN regexp_replace(county_parish_std, 'Santa Luzia ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Magdalena %' THEN regexp_replace(county_parish_std, 'Santa Magdalena ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Maria Das %' THEN regexp_replace(county_parish_std, 'Santa Maria Das ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Maria da %' THEN regexp_replace(county_parish_std, 'Santa Maria da ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Maria del %' THEN regexp_replace(county_parish_std, 'Santa Maria del ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Maria Do %' THEN regexp_replace(county_parish_std, 'Santa Maria Do ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Maria %' THEN regexp_replace(county_parish_std, 'Santa Maria ', '', 'i')
WHEN county_parish_std ILIKE 'Santana Da %' THEN regexp_replace(county_parish_std, 'Santana Da ', '', 'i')
WHEN county_parish_std ILIKE 'Santana De %' THEN regexp_replace(county_parish_std, 'Santana De ', '', 'i')
WHEN county_parish_std ILIKE 'Santana Do %' THEN regexp_replace(county_parish_std, 'Santana Do ', '', 'i')
WHEN county_parish_std ILIKE 'Santana Dos %' THEN regexp_replace(county_parish_std, 'Santana Dos ', '', 'i')
WHEN county_parish_std ILIKE 'Santander de %' THEN regexp_replace(county_parish_std, 'Santander de ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Rita De %' THEN regexp_replace(county_parish_std, 'Santa Rita De ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Rita Do %' THEN regexp_replace(county_parish_std, 'Santa Rita Do ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Rosa de %' THEN regexp_replace(county_parish_std, 'Santa Rosa de ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Rosa Da %' THEN regexp_replace(county_parish_std, 'Santa Rosa Da ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Tereza De %' THEN regexp_replace(county_parish_std, 'Santa Tereza De ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Tereza Do %' THEN regexp_replace(county_parish_std, 'Santa Tereza Do ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Terezinha De %' THEN regexp_replace(county_parish_std, 'Santa Terezinha De ', '', 'i')
WHEN county_parish_std ILIKE 'Santa Vitoria Do %' THEN regexp_replace(county_parish_std, 'Santa Vitoria Do ', '', 'i')
WHEN county_parish_std ILIKE 'Santiago de %' THEN regexp_replace(county_parish_std, 'Santiago de ', '', 'i')
WHEN county_parish_std ILIKE 'Santiago do %' THEN regexp_replace(county_parish_std, 'Santiago do ', '', 'i')
WHEN county_parish_std ILIKE 'Santiago %' THEN regexp_replace(county_parish_std, 'Santiago ', '', 'i')
WHEN county_parish_std ILIKE 'Santo Amaro Das %' THEN regexp_replace(county_parish_std, 'Santo Amaro Das ', '', 'i')
WHEN county_parish_std ILIKE 'Santo Amaro Da %' THEN regexp_replace(county_parish_std, 'Santo Amaro Da ', '', 'i')
WHEN county_parish_std ILIKE 'Santo Amaro Do %' THEN regexp_replace(county_parish_std, 'Santo Amaro Do ', '', 'i')
WHEN county_parish_std ILIKE 'Santo Antonio Das %' THEN regexp_replace(county_parish_std, 'Santo Antonio Das ', '', 'i')
WHEN county_parish_std ILIKE 'Santo Antonio Da %' THEN regexp_replace(county_parish_std, 'Santo Antonio Da ', '', 'i')
WHEN county_parish_std ILIKE 'Santo Antonio De %' THEN regexp_replace(county_parish_std, 'Santo Antonio De ', '', 'i')
WHEN county_parish_std ILIKE 'Santo Antonio Do %' THEN regexp_replace(county_parish_std, 'Santo Antonio Do ', '', 'i')
WHEN county_parish_std ILIKE 'Santo Domingo %' THEN regexp_replace(county_parish_std, 'Santo Domingo ', '', 'i')
WHEN county_parish_std ILIKE 'Santo Inacio Do %' THEN regexp_replace(county_parish_std, 'Santo Inacio Do ', '', 'i')
WHEN county_parish_std ILIKE 'Santos Reyes %' THEN regexp_replace(county_parish_std, 'Santos Reyes ', '', 'i')
WHEN county_parish_std ILIKE 'San Vicente del %' THEN regexp_replace(county_parish_std, 'San Vicente del ', '', 'i')
WHEN county_parish_std ILIKE 'San Vicente de %' THEN regexp_replace(county_parish_std, 'San Vicente de ', '', 'i')
WHEN county_parish_std ILIKE 'San Vicente %' THEN regexp_replace(county_parish_std, 'San Vicente ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Benedito Do Rio Preto%' THEN regexp_replace(county_parish_std, 'Sao Benedito Do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Bento De %' THEN regexp_replace(county_parish_std, 'Sao Bento De ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Bento Do %' THEN regexp_replace(county_parish_std, 'Sao Bento Do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Bras de %' THEN regexp_replace(county_parish_std, 'Sao Bras de ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Braz Do %' THEN regexp_replace(county_parish_std, 'Sao Braz Do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Caetano De Odivela%' THEN regexp_replace(county_parish_std, 'Sao Caetano De ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Carlos Do Iva%' THEN regexp_replace(county_parish_std, 'Sao Carlos Do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Domingos Das %' THEN regexp_replace(county_parish_std, 'Sao Domingos Das ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Domingos Do %' THEN regexp_replace(county_parish_std, 'Sao Domingos Do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Felix De %' THEN regexp_replace(county_parish_std, 'Sao Felix De ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Felix Do %' THEN regexp_replace(county_parish_std, 'Sao Felix Do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Francisco De %' THEN regexp_replace(county_parish_std, 'Sao Francisco De ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Gabriel Da %' THEN regexp_replace(county_parish_std, 'Sao Gabriel Da ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Geraldo Da %' THEN regexp_replace(county_parish_std, 'Sao Geraldo Da ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Geraldo Do %' THEN regexp_replace(county_parish_std, 'Sao Geraldo Do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Goncalo Do %' THEN regexp_replace(county_parish_std, 'Sao Goncalo Do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Goncalo %' THEN regexp_replace(county_parish_std, 'Sao Goncalo ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Joao Da %' THEN regexp_replace(county_parish_std, 'Sao Joao Da ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Joao Das %' THEN regexp_replace(county_parish_std, 'Sao Joao Das ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Joao D''%' THEN regexp_replace(county_parish_std, 'Sao Joao D''', '', 'i')
WHEN county_parish_std ILIKE 'Sao Joao De %' THEN regexp_replace(county_parish_std, 'Sao Joao De ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Joao Do %' THEN regexp_replace(county_parish_std, 'Sao Joao Do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Joao %' THEN regexp_replace(county_parish_std, 'Sao Joao ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Joaquim Da %' THEN regexp_replace(county_parish_std, 'Sao Joaquim Da ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Jorge Do %' THEN regexp_replace(county_parish_std, 'Sao Jorge Do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Jose Da %' THEN regexp_replace(county_parish_std, 'Sao Jose Da ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Jose Das %' THEN regexp_replace(county_parish_std, 'Sao Jose Das ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Jose De %' THEN regexp_replace(county_parish_std, 'Sao Jose De ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Jose Do %' THEN regexp_replace(county_parish_std, 'Sao Jose Do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Lourenco Da %' THEN regexp_replace(county_parish_std, 'Sao Lourenco Da ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Lourenco do %' THEN regexp_replace(county_parish_std, 'Sao Lourenco do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Luis De %' THEN regexp_replace(county_parish_std, 'Sao Luis De ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Luis Do %' THEN regexp_replace(county_parish_std, 'Sao Luis Do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Luis Gonzaga Do %' THEN regexp_replace(county_parish_std, 'Sao Luis Gonzaga Do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Luiz Gonzaga%' THEN regexp_replace(county_parish_std, 'Sao Luiz ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Manoel Do %' THEN regexp_replace(county_parish_std, 'Sao Manoel Do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Mateus Do Maranhao%' THEN regexp_replace(county_parish_std, 'Sao Mateus Do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Miguel da %' THEN regexp_replace(county_parish_std, 'Sao Miguel da ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Miguel Das %' THEN regexp_replace(county_parish_std, 'Sao Miguel Das ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Miguel De %' THEN regexp_replace(county_parish_std, 'Sao Miguel De ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Miguel Do %' THEN regexp_replace(county_parish_std, 'Sao Miguel Do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Miguel Dos %' THEN regexp_replace(county_parish_std, 'Sao Miguel Dos ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Paulo Das %' THEN regexp_replace(county_parish_std, 'Sao Paulo Das ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Paulo De %' THEN regexp_replace(county_parish_std, 'Sao Paulo De ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Paulo Do %' THEN regexp_replace(county_parish_std, 'Sao Paulo Do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Pedro Da %' THEN regexp_replace(county_parish_std, 'Sao Pedro Da ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Pedro Das %' THEN regexp_replace(county_parish_std, 'Sao Pedro Das ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Pedro Do %' THEN regexp_replace(county_parish_std, 'Sao Pedro Do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Pedro dos %' THEN regexp_replace(county_parish_std, 'Sao Pedro dos ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Raimundo Das %' THEN regexp_replace(county_parish_std, 'Sao Raimundo Das ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Raimundo Do %' THEN regexp_replace(county_parish_std, 'Sao Raimundo Do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Raimundo %' THEN regexp_replace(county_parish_std, 'Sao Raimundo ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Roque De %' THEN regexp_replace(county_parish_std, 'Sao Roque De ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Roque do %' THEN regexp_replace(county_parish_std, 'Sao Roque do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Salvador Do %' THEN regexp_replace(county_parish_std, 'Sao Salvador Do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Sebastiao Da %' THEN regexp_replace(county_parish_std, 'Sao Sebastiao Da ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Sebastiao De %' THEN regexp_replace(county_parish_std, 'Sao Sebastiao De ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Sebastiao Do %' THEN regexp_replace(county_parish_std, 'Sao Sebastiao Do ', '', 'i')
WHEN county_parish_std ILIKE 'Sao Vicente De Minas%' THEN regexp_replace(county_parish_std, 'Sao Vicente De ', '', 'i')
WHEN county_parish_std ILIKE 'Tamazulapam del Espiritu Santo%' THEN regexp_replace(county_parish_std, ' del Espiritu Santo', '', 'i')
WHEN county_parish_std ILIKE 'Villa de San Diego de %' THEN regexp_replace(county_parish_std, 'Villa de San Diego de ', '', 'i')
WHEN county_parish_std ILIKE 'Villa de %' THEN regexp_replace(county_parish_std, 'Villa de ', '', 'i')
WHEN county_parish_std ILIKE 'Ville de %' THEN regexp_replace(county_parish_std, 'Ville de ', '', 'i')
WHEN county_parish_std ILIKE 'Wahlkreis %' THEN regexp_replace(county_parish_std, 'Wahlkreis ', '', 'i')
WHEN county_parish_std ILIKE 'Ward of %' THEN regexp_replace(county_parish_std, 'Ward of ', '', 'i')
WHEN county_parish_std ILIKE 'State of %' THEN regexp_replace(county_parish_std, 'State of ', '', 'i')
WHEN county_parish_std ILIKE 'Union Territory of %' THEN regexp_replace(county_parish_std, 'Union Territory of ', '', 'i')
WHEN county_parish_std ILIKE 'Wilaya de %' THEN regexp_replace(county_parish_std, 'Wilaya de ', '', 'i')
ELSE county_parish_std
END;

-- Prefixes without articles
UPDATE county_parish
SET county_parish_std=
CASE
WHEN county_parish_std ILIKE 'Amphoe%' THEN regexp_replace(county_parish_std, 'Amphoe', '', 'i')
WHEN county_parish_std ILIKE 'Arrondissement %' THEN regexp_replace(county_parish_std, 'Arrondissement ', '', 'i')
WHEN county_parish_std ILIKE 'Bashkia%' THEN regexp_replace(county_parish_std, 'Bashkia', '', 'i')
WHEN county_parish_std ILIKE 'Bezirk%' THEN regexp_replace(county_parish_std, 'Bezirk', '', 'i')
WHEN county_parish_std ILIKE 'Canton%' THEN regexp_replace(county_parish_std, 'Canton', '', 'i')
WHEN county_parish_std ILIKE 'Concelho%' THEN regexp_replace(county_parish_std, 'Concelho', '', 'i')
WHEN county_parish_std ILIKE 'Changwat%' THEN regexp_replace(county_parish_std, 'Changwat', '', 'i')
WHEN county_parish_std ILIKE 'Circunscricao%' THEN regexp_replace(county_parish_std, 'Circunscricao', '', 'i')
WHEN county_parish_std ILIKE 'County %' THEN regexp_replace(county_parish_std, 'County ', '', 'i')
WHEN county_parish_std ILIKE 'Comuna %' THEN regexp_replace(county_parish_std, 'Comuna ', '', 'i')
WHEN county_parish_std ILIKE 'Departamento%' THEN regexp_replace(county_parish_std, 'Departamento', '', 'i')
WHEN county_parish_std ILIKE 'Departament%' THEN regexp_replace(county_parish_std, 'Departament', '', 'i')
WHEN county_parish_std ILIKE 'Departement%' THEN regexp_replace(county_parish_std, 'Departement', '', 'i')
WHEN county_parish_std ILIKE 'Distrito%' THEN regexp_replace(county_parish_std, 'Distrito', '', 'i')
WHEN county_parish_std ILIKE 'Estado%' THEN regexp_replace(county_parish_std, 'Estado', '', 'i')
WHEN county_parish_std ILIKE 'Gemeente %' THEN regexp_replace(county_parish_std, 'Gemeente ', '', 'i')
WHEN county_parish_std ILIKE 'Gorod %' THEN regexp_replace(county_parish_std, 'Gorod ', '', 'i')
WHEN county_parish_std ILIKE 'Gorodskoy okrug %' THEN regexp_replace(county_parish_std, 'Gorodskoy okrug ', '', 'i')
WHEN county_parish_std ILIKE 'Gouvernorat%' THEN regexp_replace(county_parish_std, 'Gouvernorat', '', 'i')
WHEN county_parish_std ILIKE 'Grad %' THEN regexp_replace(county_parish_std, 'Grad ', '', 'i')
WHEN county_parish_std ILIKE 'Horad %' THEN regexp_replace(county_parish_std, 'Horad ', '', 'i')
WHEN county_parish_std ILIKE 'Huyen %' THEN regexp_replace(county_parish_std, 'Huyen ', '', 'i')
WHEN county_parish_std ILIKE 'Kanton%' THEN regexp_replace(county_parish_std, 'Kanton', '', 'i')
WHEN county_parish_std ILIKE 'Kabupaten %' THEN regexp_replace(county_parish_std, 'Kabupaten ', '', 'i')
WHEN county_parish_std ILIKE 'Kota Administrasi Jakarta %' THEN regexp_replace(county_parish_std, 'Kota Administrasi Jakarta ', '', 'i')
WHEN county_parish_std ILIKE 'Kota %' THEN regexp_replace(county_parish_std, 'Kota ', '', 'i')
WHEN county_parish_std ILIKE 'Liwa'' %' THEN regexp_replace(county_parish_std, 'Liwa'' ', '', 'i')
WHEN county_parish_std ILIKE 'Markaz %' THEN regexp_replace(county_parish_std, 'Markaz ', '', 'i')
WHEN county_parish_std ILIKE 'Muang %' THEN regexp_replace(county_parish_std, 'Muang ', '', 'i')
WHEN county_parish_std ILIKE 'Mudiriyat %' THEN regexp_replace(county_parish_std, 'Mudiriyat ', '', 'i')
WHEN county_parish_std ILIKE 'Municipio %' THEN regexp_replace(county_parish_std, 'Municipio ', '', 'i')
WHEN county_parish_std ILIKE 'Municipiul %' THEN regexp_replace(county_parish_std, 'Municipiul ', '', 'i')
WHEN county_parish_std ILIKE 'Nohiyai %' THEN regexp_replace(county_parish_std, 'Nohiyai ', '', 'i')
WHEN county_parish_std ILIKE 'Nomarchia %' THEN regexp_replace(county_parish_std, 'Nomarchia ', '', 'i')
WHEN county_parish_std ILIKE 'Nomos %' THEN regexp_replace(county_parish_std, 'Nomos ', '', 'i')
WHEN county_parish_std ILIKE 'Obcina%' THEN regexp_replace(county_parish_std, 'Obcina', '', 'i')
WHEN county_parish_std ILIKE 'Obshtina %' THEN regexp_replace(county_parish_std, 'Obshtina ', '', 'i')
WHEN county_parish_std ILIKE 'Opstina %' THEN regexp_replace(county_parish_std, 'Opstina ', '', 'i')
WHEN county_parish_std ILIKE 'Okres %' THEN regexp_replace(county_parish_std, 'Okres ', '', 'i')
WHEN county_parish_std ILIKE 'Oras %' THEN regexp_replace(county_parish_std, 'Oras ', '', 'i')
WHEN county_parish_std ILIKE 'Parish%' THEN regexp_replace(county_parish_std, 'Parish', '', 'i')
WHEN county_parish_std ILIKE 'Politischer Bezirk %' THEN regexp_replace(county_parish_std, 'Politischer Bezirk ', '', 'i')
WHEN county_parish_std ILIKE 'Powiat %' THEN regexp_replace(county_parish_std, 'Powiat ', '', 'i')
WHEN county_parish_std ILIKE 'Prefecture %' THEN regexp_replace(county_parish_std, 'Prefecture ', '', 'i')
WHEN county_parish_std ILIKE 'Principality%' THEN regexp_replace(county_parish_std, 'Principality', '', 'i')
WHEN county_parish_std ILIKE 'Province%' THEN regexp_replace(county_parish_std, 'Province', '', 'i')
WHEN county_parish_std ILIKE 'Provincia%' THEN regexp_replace(county_parish_std, 'Provincia', '', 'i')
WHEN county_parish_std ILIKE 'Provinsi%' THEN regexp_replace(county_parish_std, 'Provinsi', '', 'i')
WHEN county_parish_std ILIKE 'Qada'' %' THEN regexp_replace(county_parish_std, 'Qada'' ', '', 'i')
WHEN county_parish_std ILIKE 'Qeza-i %' THEN regexp_replace(county_parish_std, 'Qeza-i ', '', 'i')
WHEN county_parish_std ILIKE 'Quan %' THEN regexp_replace(county_parish_std, 'Quan ', '', 'i')
WHEN county_parish_std ILIKE 'Region %' THEN regexp_replace(county_parish_std, 'Region ', '', 'i')
WHEN county_parish_std ILIKE 'Regierungsbezirk %' THEN regexp_replace(county_parish_std, 'Regierungsbezirk ', '', 'i')
WHEN county_parish_std ILIKE 'Rrethi i %' THEN regexp_replace(county_parish_std, 'Rrethi i ', '', 'i')
WHEN county_parish_std ILIKE 'State %' THEN regexp_replace(county_parish_std, 'State ', '', 'i')
WHEN county_parish_std ILIKE 'Shahrestan-e %' THEN regexp_replace(county_parish_std, 'Shahrestan-e ', '', 'i')
WHEN county_parish_std ILIKE 'Srok %' THEN regexp_replace(county_parish_std, 'Srok ', '', 'i')
WHEN county_parish_std ILIKE 'Sveitarfelagid %' THEN regexp_replace(county_parish_std, 'Sveitarfelagid ', '', 'i')
WHEN county_parish_std ILIKE 'Thanh Pho %' THEN regexp_replace(county_parish_std, 'Thanh Pho ', '', 'i')
WHEN county_parish_std ILIKE 'Thi Xa %' THEN regexp_replace(county_parish_std, 'Thi Xa ', '', 'i')
WHEN county_parish_std ILIKE 'Union Territory%' THEN regexp_replace(county_parish_std, 'Union Territory', '', 'i')
WHEN county_parish_std ILIKE 'Wilaya%' THEN regexp_replace(county_parish_std, 'Wilaya', '', 'i')
WHEN county_parish_std ILIKE 'Tinh%' THEN regexp_replace(county_parish_std, 'Tinh', '', 'i')
ELSE county_parish_std
END;

-- Suffixes
UPDATE county_parish
SET county_parish_std=
CASE
WHEN county_parish_std ILIKE '%  Administrativnyy Okrug' THEN regexp_replace(county_parish_std, ' Administrativnyy Okrug', '', 'i')
WHEN county_parish_std ILIKE '% Audany' THEN regexp_replace(county_parish_std, ' Audany', '', 'i')
WHEN county_parish_std ILIKE '% District' THEN regexp_replace(county_parish_std, 'District', '', 'i')
WHEN county_parish_std ILIKE '% County' THEN regexp_replace(county_parish_std, ' County', '', 'i')
WHEN county_parish_std ILIKE '% Parish' THEN regexp_replace(county_parish_std, 'Parish', '', 'i')
WHEN county_parish_std ILIKE '% Department' THEN regexp_replace(county_parish_std, ' Department', '', 'i')
WHEN county_parish_std ILIKE '% District' THEN regexp_replace(county_parish_std, ' District', '', 'i')
WHEN county_parish_std ILIKE '% Division' THEN regexp_replace(county_parish_std, ' Division', '', 'i')
WHEN county_parish_std ILIKE '% Municipality' THEN regexp_replace(county_parish_std, 'Municipality', '', 'i')
WHEN county_parish_std ILIKE '% Munitsip''alit''et''i' THEN regexp_replace(county_parish_std, ' Munitsip''alit''et''i', '', 'i')
WHEN county_parish_std ILIKE '% Mis''krada' THEN regexp_replace(county_parish_std, 'Mis''krada', '', 'i')
WHEN county_parish_std ILIKE '% Municipio' THEN regexp_replace(county_parish_std, 'Municipio', '', 'i')
WHEN county_parish_std ILIKE '% Province' THEN regexp_replace(county_parish_std, ' Province', '', 'i')
WHEN county_parish_std ILIKE '% pagasts' THEN regexp_replace(county_parish_std, ' pagasts', '', 'i')
WHEN county_parish_std ILIKE '% Qalasy' THEN regexp_replace(county_parish_std, ' Qalasy', '', 'i')
WHEN county_parish_std ILIKE '% Region' THEN regexp_replace(county_parish_std, ' Region', '', 'i')
WHEN county_parish_std ILIKE '% Rayon' THEN regexp_replace(county_parish_std, ' Rayon', '', 'i')
WHEN county_parish_std ILIKE '% Territory' THEN regexp_replace(county_parish_std, 'Territory', '', 'i')
ELSE county_parish_std
END;

-- Suffixes
UPDATE county_parish
SET county_parish_std=TRIM(county_parish_std)
;

-- REstore errors
UPDATE county_parish
SET county_parish_std=county_parish_ascii
WHERE county_parish_ascii LIKE 'Comuna 1%'
OR county_parish_ascii LIKE 'Comuna 2%'
OR county_parish_ascii LIKE 'Comuna 3%'
OR county_parish_ascii LIKE 'Comuna 4%'
OR county_parish_ascii LIKE 'Comuna 5%'
OR county_parish_ascii LIKE 'Comuna 6%'
OR county_parish_ascii LIKE 'Comuna 7%'
OR county_parish_ascii LIKE 'Comuna 8%'
OR county_parish_ascii LIKE 'Comuna 9%'
;
UPDATE county_parish
SET county_parish_std=county_parish_ascii
WHERE county_parish_ascii='Quan 12'
;
UPDATE county_parish
SET county_parish_std=county_parish_ascii
WHERE county_parish_ascii='San Cristobal De Casas'
;
UPDATE county_parish
SET county_parish_std='San Jeronimo'
WHERE county_parish_ascii='San Jeronimo Department'
;
UPDATE county_parish
SET county_parish_std=county_parish_ascii
WHERE county_parish_ascii='San Sebastian del Oeste'
;
UPDATE county_parish
SET county_parish_std=county_parish_ascii
WHERE county_parish_ascii IN (
'Santa Barbara D''Oeste',
'Santa Barbara Do Sul',
'Santa Fe Do Sul',
'Santa Izabel Do Oeste',
'Santa Lucia del Camino',
'Santa Luzia Do Norte',
'Santa Luzia D''Oeste',
'Santa Maria Da Serra',
'Santa Maria Do Oeste',
'Santa Maria del Rio',
'Santa Maria del Real',
'Santa Rosa Do Sul',
'Santa Tereza Do Oeste',
'Santiago Do Sul',
'Santo Antonio Do Leste',
'Santo Antonio Do Sudoeste',
'Santo Domingo Este',
'Santo Domingo Norte',
'Santo Domingo Oeste',
'Sao Bento Do Sul',
'Sao Bento do Norte',
'Sao Domingos Do Norte',
'Sao Domingos Do Sul',
'Sao Francisco Do Oeste',
'Sao Francisco Do Sul',
'Sao Gabriel Do Oeste',
'Sao Joao Do Oeste',
'Sao Joao Do Oriente',
'Sao Joao Do Sul',
'Sao Lourenco do Oeste',
'Sao Lourenco Do Sul',
'Sao Pedro Do Sul',
'Sao Pedro do Sul',
'Sao Sebastiao Do Oeste',
'Santa Barbara Do Leste'
)
;

CREATE INDEX county_parish_county_parish_std ON county_parish (county_parish_std);
CREATE INDEX county_parish_county_parish_std_ci_idx ON county_parish USING btree (LOWER(county_parish_std));

