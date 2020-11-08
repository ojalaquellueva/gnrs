-- ------------------------------------------------------------
--  Populates column county_parish_verbatim_alt
--
-- = county_parish_verbatim stripped of categorical identifiers
-- such as "State", "Department", "Departamento de", 
-- "Municipio de", etc.
--
-- Requires parameter: :'job'

-- ------------------------------------------------------------

-- Prefixes including article 'de', 'of', etc.
UPDATE user_data
SET county_parish_verbatim_alt=
CASE
WHEN county_parish_verbatim ILIKE 'Arrondissement des%' THEN regexp_replace(county_parish_verbatim, 'Arrondissement des', '', 'i')
WHEN county_parish_verbatim ILIKE 'Arrondissement de%' THEN regexp_replace(county_parish_verbatim, 'Arrondissement de', '', 'i')
WHEN county_parish_verbatim ILIKE 'Arrondissement du%' THEN regexp_replace(county_parish_verbatim, 'Arrondissement du', '', 'i')
WHEN county_parish_verbatim ILIKE 'Borough of %' THEN regexp_replace(county_parish_verbatim, 'Borough of ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Canton de%' THEN regexp_replace(county_parish_verbatim, 'Canton de', '', 'i')
WHEN county_parish_verbatim ILIKE 'Castello di%' THEN regexp_replace(county_parish_verbatim, 'Castello di', '', 'i')
WHEN county_parish_verbatim ILIKE 'Commune de%' THEN regexp_replace(county_parish_verbatim, 'Commune de', '', 'i')
WHEN county_parish_verbatim ILIKE 'Concelho do%' THEN regexp_replace(county_parish_verbatim, 'Concelho do', '', 'i')
WHEN county_parish_verbatim ILIKE 'Concelho da%' THEN regexp_replace(county_parish_verbatim, 'Concelho da', '', 'i')
WHEN county_parish_verbatim ILIKE 'Concelho de%' THEN regexp_replace(county_parish_verbatim, 'Concelho de', '', 'i')
WHEN county_parish_verbatim ILIKE 'Circunscricao da %' THEN regexp_replace(county_parish_verbatim, 'Circunscricao da ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Circunscricao de %' THEN regexp_replace(county_parish_verbatim, 'Circunscricao de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Circunscricao do %' THEN regexp_replace(county_parish_verbatim, 'Circunscricao do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'City and Borough of %' THEN regexp_replace(county_parish_verbatim, 'City and Borough of ', '', 'i')
WHEN county_parish_verbatim ILIKE 'City and County of%' THEN regexp_replace(county_parish_verbatim, 'City and County of', '', 'i')
WHEN county_parish_verbatim ILIKE 'City of%' THEN regexp_replace(county_parish_verbatim, 'City of', '', 'i')
WHEN county_parish_verbatim ILIKE 'Commune of%' THEN regexp_replace(county_parish_verbatim, 'Commune of', '', 'i')
WHEN county_parish_verbatim ILIKE 'Delegation de %' THEN regexp_replace(county_parish_verbatim, 'Delegation de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Delegation d''%' THEN regexp_replace(county_parish_verbatim, 'Delegation d''', '', 'i')
WHEN county_parish_verbatim ILIKE 'Departement des %' THEN regexp_replace(county_parish_verbatim, 'Departement des ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Departement du %' THEN regexp_replace(county_parish_verbatim, 'Departement du ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Departement d''' THEN regexp_replace(county_parish_verbatim, 'Departement d''', '', 'i')
WHEN county_parish_verbatim ILIKE 'Departement de la %' THEN regexp_replace(county_parish_verbatim, 'Departement de la ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Departement de l''%' THEN regexp_replace(county_parish_verbatim, 'Departement de l''', '', 'i')
WHEN county_parish_verbatim ILIKE 'Departamento del%' THEN regexp_replace(county_parish_verbatim, 'Departamento del', '', 'i')
WHEN county_parish_verbatim ILIKE 'Departamento de%' THEN regexp_replace(county_parish_verbatim, 'Departamento de', '', 'i')
WHEN county_parish_verbatim ILIKE 'Departament of%' THEN regexp_replace(county_parish_verbatim, 'Departament of', '', 'i')
WHEN county_parish_verbatim ILIKE 'Departement de%' THEN regexp_replace(county_parish_verbatim, 'Departement de', '', 'i')
WHEN county_parish_verbatim ILIKE 'Distrito del%' THEN regexp_replace(county_parish_verbatim, 'Distrito del', '', 'i')
WHEN county_parish_verbatim ILIKE 'Distrito da%' THEN regexp_replace(county_parish_verbatim, 'Distrito da', '', 'i')
WHEN county_parish_verbatim ILIKE 'Distrito do%' THEN regexp_replace(county_parish_verbatim, 'Distrito do', '', 'i')
WHEN county_parish_verbatim ILIKE 'Distrito de%' THEN regexp_replace(county_parish_verbatim, 'Distrito de', '', 'i')
WHEN county_parish_verbatim ILIKE 'Estado de%' THEN regexp_replace(county_parish_verbatim, 'Estado de', '', 'i')
WHEN county_parish_verbatim ILIKE 'Gouvernorat de%' THEN regexp_replace(county_parish_verbatim, 'Gouvernorat de', '', 'i')
WHEN county_parish_verbatim ILIKE 'Heroica Ciudad de %' THEN regexp_replace(county_parish_verbatim, 'Heroica Ciudad de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Heroica Villa de %' THEN regexp_replace(county_parish_verbatim, 'Heroica Villa de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Heroica Villa %' THEN regexp_replace(county_parish_verbatim, 'Heroica Villa ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Komuna e %' THEN regexp_replace(county_parish_verbatim, 'Komuna e ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Municipio Autonomo %' THEN regexp_replace(county_parish_verbatim, 'Municipio Autonomo ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Municipio de%' THEN regexp_replace(county_parish_verbatim, 'Municipio de', '', 'i')
WHEN county_parish_verbatim ILIKE 'Municipio Especial%' THEN regexp_replace(county_parish_verbatim, 'Municipio Especial', '', 'i')
WHEN county_parish_verbatim ILIKE 'Parish of%' THEN regexp_replace(county_parish_verbatim, 'Parish of', '', 'i')
WHEN county_parish_verbatim ILIKE 'Partido de %' THEN regexp_replace(county_parish_verbatim, 'Partido de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Prefecture de la%' THEN regexp_replace(county_parish_verbatim, 'Prefecture de la', '', 'i')
WHEN county_parish_verbatim ILIKE 'Prefecture de%' THEN regexp_replace(county_parish_verbatim, 'Prefecture de', '', 'i')
WHEN county_parish_verbatim ILIKE 'Principality of%' THEN regexp_replace(county_parish_verbatim, 'Principality of', '', 'i')
WHEN county_parish_verbatim ILIKE 'Province of%' THEN regexp_replace(county_parish_verbatim, 'Province of', '', 'i')
WHEN county_parish_verbatim ILIKE 'Provincia del%' THEN regexp_replace(county_parish_verbatim, 'Provincia del', '', 'i')
WHEN county_parish_verbatim ILIKE 'Provincia de%' THEN regexp_replace(county_parish_verbatim, 'Provincia de', '', 'i')
WHEN county_parish_verbatim ILIKE 'Province du%' THEN regexp_replace(county_parish_verbatim, 'Province du', '', 'i')
WHEN county_parish_verbatim ILIKE 'Province de%' THEN regexp_replace(county_parish_verbatim, 'Province de', '', 'i')
WHEN county_parish_verbatim ILIKE 'Qada'' al %' THEN regexp_replace(county_parish_verbatim, 'Qada'' al ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Qada'' ar %' THEN regexp_replace(county_parish_verbatim, 'Qada'' ar ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Qada'' as %' THEN regexp_replace(county_parish_verbatim, 'Qada'' as ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Qada'' at %' THEN regexp_replace(county_parish_verbatim, 'Qada'' at ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Qada'' `%' THEN regexp_replace(county_parish_verbatim, 'Qada'' `', '', 'i')
WHEN county_parish_verbatim ILIKE 'Regional District of %' THEN regexp_replace(county_parish_verbatim, 'Regional District of ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Qarku i%' THEN regexp_replace(county_parish_verbatim, 'Qarku i', '', 'i')
WHEN county_parish_verbatim ILIKE 'Region del%' THEN regexp_replace(county_parish_verbatim, 'Region del', '', 'i')
WHEN county_parish_verbatim ILIKE 'Region du %' THEN regexp_replace(county_parish_verbatim, 'Region du ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Region de %' THEN regexp_replace(county_parish_verbatim, 'Region de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Agustin del %' THEN regexp_replace(county_parish_verbatim, 'San Agustin del ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Agustin de %' THEN regexp_replace(county_parish_verbatim, 'San Agustin de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Agustin %' THEN regexp_replace(county_parish_verbatim, 'San Agustin ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Andres del %' THEN regexp_replace(county_parish_verbatim, 'San Andres del ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Andres de %' THEN regexp_replace(county_parish_verbatim, 'San Andres  ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Andres %' THEN regexp_replace(county_parish_verbatim, 'San Andres ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Antonino del %' THEN regexp_replace(county_parish_verbatim, 'San Antonino del ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Antonino de %' THEN regexp_replace(county_parish_verbatim, 'San Antonino ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Antonino %' THEN regexp_replace(county_parish_verbatim, 'xxx', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Antonino %' THEN regexp_replace(county_parish_verbatim, 'San Antonino ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Baltazar %' THEN regexp_replace(county_parish_verbatim, 'San Baltazar ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Bartolo %' THEN regexp_replace(county_parish_verbatim, 'San Bartolo ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Bartolome %' THEN regexp_replace(county_parish_verbatim, 'San Bartolome ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Carlos Yautepec%' THEN regexp_replace(county_parish_verbatim, 'Yautepec', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Cristobal de %' THEN regexp_replace(county_parish_verbatim, 'San Cristobal de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Damian %' THEN regexp_replace(county_parish_verbatim, 'San Damian ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Diego la Mesa %' THEN regexp_replace(county_parish_verbatim, 'San Diego la Mesa ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Diego de %' THEN regexp_replace(county_parish_verbatim, 'San Diego de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Diego %' THEN regexp_replace(county_parish_verbatim, 'San Diego ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Dionisio del %' THEN regexp_replace(county_parish_verbatim, 'San Dionisio del ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Dionisio %' THEN regexp_replace(county_parish_verbatim, 'San Dionisio ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Felipe del %' THEN regexp_replace(county_parish_verbatim, 'San Felipe del ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Felipe de %' THEN regexp_replace(county_parish_verbatim, 'San Felipe de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Felipe %' THEN regexp_replace(county_parish_verbatim, 'San Felipe ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Francisco del %' THEN regexp_replace(county_parish_verbatim, 'San Francisco del ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Francisco de %' THEN regexp_replace(county_parish_verbatim, 'San Francisco de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Francisco %' THEN regexp_replace(county_parish_verbatim, 'San Francisco ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Gabriel %' THEN regexp_replace(county_parish_verbatim, 'San Gabriel ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Gregorio De %' THEN regexp_replace(county_parish_verbatim, 'San Gregorio De ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Gregorio %' THEN regexp_replace(county_parish_verbatim, 'San Gregorio ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Ignacio de %' THEN regexp_replace(county_parish_verbatim, 'San Ignacio de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Ignacio %' THEN regexp_replace(county_parish_verbatim, 'San Ignacio ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Ildefonso %' THEN regexp_replace(county_parish_verbatim, 'San Ildefonso ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Isidro %' THEN regexp_replace(county_parish_verbatim, 'San Isidro ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Jeronimo %' THEN regexp_replace(county_parish_verbatim, 'San Jeronimo ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Jose del %' THEN regexp_replace(county_parish_verbatim, 'San Jose del ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Jose de %' THEN regexp_replace(county_parish_verbatim, 'San Jose de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Jose %' THEN regexp_replace(county_parish_verbatim, 'San Jose ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Juan Bautista %' THEN regexp_replace(county_parish_verbatim, 'San Juan Bautista ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Juan del %' THEN regexp_replace(county_parish_verbatim, 'San Juan del ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Juan de %' THEN regexp_replace(county_parish_verbatim, 'San Juan de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Juan %' THEN regexp_replace(county_parish_verbatim, 'San Juan ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Lorenzo %' THEN regexp_replace(county_parish_verbatim, 'San Lorenzo ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Lucas %' THEN regexp_replace(county_parish_verbatim, 'San Lucas ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Luis del %' THEN regexp_replace(county_parish_verbatim, 'San Luis del ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Luis de %' THEN regexp_replace(county_parish_verbatim, 'San Luis de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Luis %' THEN regexp_replace(county_parish_verbatim, 'San Luis ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Manuel de %' THEN regexp_replace(county_parish_verbatim, 'San Manuel de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Manuel %' THEN regexp_replace(county_parish_verbatim, 'San Manuel ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Marcial %' THEN regexp_replace(county_parish_verbatim, 'San Marcial ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Martin de %' THEN regexp_replace(county_parish_verbatim, 'San Martin de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Martin ' THEN regexp_replace(county_parish_verbatim, 'San Martin ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Mateo del %' THEN regexp_replace(county_parish_verbatim, 'San Mateo del ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Mateo de %' THEN regexp_replace(county_parish_verbatim, 'San Mateo de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Mateo %' THEN regexp_replace(county_parish_verbatim, 'San Mateo ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Matias %' THEN regexp_replace(county_parish_verbatim, 'San Matias ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Melchor %' THEN regexp_replace(county_parish_verbatim, 'San Melchor ', '', 'i')
WHEN county_parish_verbatim ILIKE 'xxSan Miguel del x%' THEN regexp_replace(county_parish_verbatim, 'San Miguel del ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Miguel de %' THEN regexp_replace(county_parish_verbatim, 'San Miguel de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Miguel %' THEN regexp_replace(county_parish_verbatim, 'San Miguel ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Nicolas de %' THEN regexp_replace(county_parish_verbatim, 'San Nicolas de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Nicolas %' THEN regexp_replace(county_parish_verbatim, 'San Nicolas ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Pablo del %' THEN regexp_replace(county_parish_verbatim, 'San Pablo del ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Pablo de %' THEN regexp_replace(county_parish_verbatim, 'San Pablo de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Pablo %' THEN regexp_replace(county_parish_verbatim, 'San Pablo ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Patricio %' THEN regexp_replace(county_parish_verbatim, 'San Patricio ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Pedro del %' THEN regexp_replace(county_parish_verbatim, 'San Pedro del ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Pedro de %' THEN regexp_replace(county_parish_verbatim, 'San Pedro de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Pedro %' THEN regexp_replace(county_parish_verbatim, 'San Pedro ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Pedro y San Pablo %' THEN regexp_replace(county_parish_verbatim, 'San Pedro y San Pablo ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Rafael del %' THEN regexp_replace(county_parish_verbatim, 'San Rafael del ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Raymundo %' THEN regexp_replace(county_parish_verbatim, 'San Raymundo ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Salvador %' THEN regexp_replace(county_parish_verbatim, 'San Salvador ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Sebastian de %' THEN regexp_replace(county_parish_verbatim, 'San Sebastian de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Sebastian %' THEN regexp_replace(county_parish_verbatim, 'San Sebastian ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Simon de %' THEN regexp_replace(county_parish_verbatim, 'San Simon de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Simon %' THEN regexp_replace(county_parish_verbatim, 'San Simon ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Ana de %' THEN regexp_replace(county_parish_verbatim, 'Santa Ana de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Ana %' THEN regexp_replace(county_parish_verbatim, 'Santa Ana ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Apolonia %' THEN regexp_replace(county_parish_verbatim, 'Santa Apolonia ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Barbara de %' THEN regexp_replace(county_parish_verbatim, 'Santa Barbara de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Barbara Do %' THEN regexp_replace(county_parish_verbatim, 'xxx', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Barbara Do %' THEN regexp_replace(county_parish_verbatim, 'xxx', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Catalina %' THEN regexp_replace(county_parish_verbatim, 'Santa Catalina ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Catarina %' THEN regexp_replace(county_parish_verbatim, 'Santa Catarina ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Cruz Da %' THEN regexp_replace(county_parish_verbatim, 'Santa Cruz Da ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Cruz Das %' THEN regexp_replace(county_parish_verbatim, 'Santa Cruz Das ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Cruz de %' THEN regexp_replace(county_parish_verbatim, 'Santa Cruz de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Cruz %' THEN regexp_replace(county_parish_verbatim, 'Santa Cruz ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santafe de Antioquia%' THEN regexp_replace(county_parish_verbatim, 'Santafe de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Fe De %' THEN regexp_replace(county_parish_verbatim, 'Santa Fe De ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Fe Do %' THEN regexp_replace(county_parish_verbatim, 'Santa Fe Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Fe %' THEN regexp_replace(county_parish_verbatim, 'Santa Fe ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Filomena Do %' THEN regexp_replace(county_parish_verbatim, 'Santa Filomena Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Helena De %' THEN regexp_replace(county_parish_verbatim, 'Santa Helena De ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Ines de %' THEN regexp_replace(county_parish_verbatim, 'Santa Ines de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Ines %' THEN regexp_replace(county_parish_verbatim, 'Santa Ines ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Isabel Do %' THEN regexp_replace(county_parish_verbatim, 'Santa Isabel Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Isabel %' THEN regexp_replace(county_parish_verbatim, 'Santa Isabel ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Lucia %' THEN regexp_replace(county_parish_verbatim, 'Santa Lucia ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Luzia do %' THEN regexp_replace(county_parish_verbatim, 'Santa Luzia do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Luzia %' THEN regexp_replace(county_parish_verbatim, 'Santa Luzia ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Magdalena %' THEN regexp_replace(county_parish_verbatim, 'Santa Magdalena ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Maria Das %' THEN regexp_replace(county_parish_verbatim, 'Santa Maria Das ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Maria da %' THEN regexp_replace(county_parish_verbatim, 'Santa Maria da ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Maria del %' THEN regexp_replace(county_parish_verbatim, 'Santa Maria del ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Maria Do %' THEN regexp_replace(county_parish_verbatim, 'Santa Maria Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Maria %' THEN regexp_replace(county_parish_verbatim, 'Santa Maria ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santana Da %' THEN regexp_replace(county_parish_verbatim, 'Santana Da ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santana De %' THEN regexp_replace(county_parish_verbatim, 'Santana De ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santana Do %' THEN regexp_replace(county_parish_verbatim, 'Santana Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santana Dos %' THEN regexp_replace(county_parish_verbatim, 'Santana Dos ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santander de %' THEN regexp_replace(county_parish_verbatim, 'Santander de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Rita De %' THEN regexp_replace(county_parish_verbatim, 'Santa Rita De ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Rita Do %' THEN regexp_replace(county_parish_verbatim, 'Santa Rita Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Rosa de %' THEN regexp_replace(county_parish_verbatim, 'Santa Rosa de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Rosa Da %' THEN regexp_replace(county_parish_verbatim, 'Santa Rosa Da ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Tereza De %' THEN regexp_replace(county_parish_verbatim, 'Santa Tereza De ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Tereza Do %' THEN regexp_replace(county_parish_verbatim, 'Santa Tereza Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Terezinha De %' THEN regexp_replace(county_parish_verbatim, 'Santa Terezinha De ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santa Vitoria Do %' THEN regexp_replace(county_parish_verbatim, 'Santa Vitoria Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santiago de %' THEN regexp_replace(county_parish_verbatim, 'Santiago de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santiago do %' THEN regexp_replace(county_parish_verbatim, 'Santiago do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santiago %' THEN regexp_replace(county_parish_verbatim, 'Santiago ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santo Amaro Das %' THEN regexp_replace(county_parish_verbatim, 'Santo Amaro Das ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santo Amaro Da %' THEN regexp_replace(county_parish_verbatim, 'Santo Amaro Da ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santo Amaro Do %' THEN regexp_replace(county_parish_verbatim, 'Santo Amaro Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santo Antonio Das %' THEN regexp_replace(county_parish_verbatim, 'Santo Antonio Das ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santo Antonio Da %' THEN regexp_replace(county_parish_verbatim, 'Santo Antonio Da ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santo Antonio De %' THEN regexp_replace(county_parish_verbatim, 'Santo Antonio De ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santo Antonio Do %' THEN regexp_replace(county_parish_verbatim, 'Santo Antonio Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santo Domingo %' THEN regexp_replace(county_parish_verbatim, 'Santo Domingo ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santo Inacio Do %' THEN regexp_replace(county_parish_verbatim, 'Santo Inacio Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Santos Reyes %' THEN regexp_replace(county_parish_verbatim, 'Santos Reyes ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Vicente del %' THEN regexp_replace(county_parish_verbatim, 'San Vicente del ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Vicente de %' THEN regexp_replace(county_parish_verbatim, 'San Vicente de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'San Vicente %' THEN regexp_replace(county_parish_verbatim, 'San Vicente ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Benedito Do Rio Preto%' THEN regexp_replace(county_parish_verbatim, 'Sao Benedito Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Bento De %' THEN regexp_replace(county_parish_verbatim, 'Sao Bento De ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Bento Do %' THEN regexp_replace(county_parish_verbatim, 'Sao Bento Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Bras de %' THEN regexp_replace(county_parish_verbatim, 'Sao Bras de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Braz Do %' THEN regexp_replace(county_parish_verbatim, 'Sao Braz Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Caetano De Odivela%' THEN regexp_replace(county_parish_verbatim, 'Sao Caetano De ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Carlos Do Iva%' THEN regexp_replace(county_parish_verbatim, 'Sao Carlos Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Domingos Das %' THEN regexp_replace(county_parish_verbatim, 'Sao Domingos Das ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Domingos Do %' THEN regexp_replace(county_parish_verbatim, 'Sao Domingos Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Felix De %' THEN regexp_replace(county_parish_verbatim, 'Sao Felix De ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Felix Do %' THEN regexp_replace(county_parish_verbatim, 'Sao Felix Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Francisco De %' THEN regexp_replace(county_parish_verbatim, 'Sao Francisco De ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Gabriel Da %' THEN regexp_replace(county_parish_verbatim, 'Sao Gabriel Da ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Geraldo Da %' THEN regexp_replace(county_parish_verbatim, 'Sao Geraldo Da ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Geraldo Do %' THEN regexp_replace(county_parish_verbatim, 'Sao Geraldo Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Goncalo Do %' THEN regexp_replace(county_parish_verbatim, 'Sao Goncalo Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Goncalo %' THEN regexp_replace(county_parish_verbatim, 'Sao Goncalo ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Joao Da %' THEN regexp_replace(county_parish_verbatim, 'Sao Joao Da ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Joao Das %' THEN regexp_replace(county_parish_verbatim, 'Sao Joao Das ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Joao D''%' THEN regexp_replace(county_parish_verbatim, 'Sao Joao D''', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Joao De %' THEN regexp_replace(county_parish_verbatim, 'Sao Joao De ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Joao Do %' THEN regexp_replace(county_parish_verbatim, 'Sao Joao Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Joao %' THEN regexp_replace(county_parish_verbatim, 'Sao Joao ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Joaquim Da %' THEN regexp_replace(county_parish_verbatim, 'Sao Joaquim Da ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Jorge Do %' THEN regexp_replace(county_parish_verbatim, 'Sao Jorge Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Jose Da %' THEN regexp_replace(county_parish_verbatim, 'Sao Jose Da ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Jose Das %' THEN regexp_replace(county_parish_verbatim, 'Sao Jose Das ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Jose De %' THEN regexp_replace(county_parish_verbatim, 'Sao Jose De ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Jose Do %' THEN regexp_replace(county_parish_verbatim, 'Sao Jose Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Lourenco Da %' THEN regexp_replace(county_parish_verbatim, 'Sao Lourenco Da ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Lourenco do %' THEN regexp_replace(county_parish_verbatim, 'Sao Lourenco do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Luis De %' THEN regexp_replace(county_parish_verbatim, 'Sao Luis De ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Luis Do %' THEN regexp_replace(county_parish_verbatim, 'Sao Luis Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Luis Gonzaga Do %' THEN regexp_replace(county_parish_verbatim, 'Sao Luis Gonzaga Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Luiz Gonzaga%' THEN regexp_replace(county_parish_verbatim, 'Sao Luiz ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Manoel Do %' THEN regexp_replace(county_parish_verbatim, 'Sao Manoel Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Mateus Do Maranhao%' THEN regexp_replace(county_parish_verbatim, 'Sao Mateus Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Miguel da %' THEN regexp_replace(county_parish_verbatim, 'Sao Miguel da ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Miguel Das %' THEN regexp_replace(county_parish_verbatim, 'Sao Miguel Das ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Miguel De %' THEN regexp_replace(county_parish_verbatim, 'Sao Miguel De ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Miguel Do %' THEN regexp_replace(county_parish_verbatim, 'Sao Miguel Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Miguel Dos %' THEN regexp_replace(county_parish_verbatim, 'Sao Miguel Dos ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Paulo Das %' THEN regexp_replace(county_parish_verbatim, 'Sao Paulo Das ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Paulo De %' THEN regexp_replace(county_parish_verbatim, 'Sao Paulo De ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Paulo Do %' THEN regexp_replace(county_parish_verbatim, 'Sao Paulo Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Pedro Da %' THEN regexp_replace(county_parish_verbatim, 'Sao Pedro Da ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Pedro Das %' THEN regexp_replace(county_parish_verbatim, 'Sao Pedro Das ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Pedro Do %' THEN regexp_replace(county_parish_verbatim, 'Sao Pedro Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Pedro dos %' THEN regexp_replace(county_parish_verbatim, 'Sao Pedro dos ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Raimundo Das %' THEN regexp_replace(county_parish_verbatim, 'Sao Raimundo Das ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Raimundo Do %' THEN regexp_replace(county_parish_verbatim, 'Sao Raimundo Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Raimundo %' THEN regexp_replace(county_parish_verbatim, 'Sao Raimundo ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Roque De %' THEN regexp_replace(county_parish_verbatim, 'Sao Roque De ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Roque do %' THEN regexp_replace(county_parish_verbatim, 'Sao Roque do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Salvador Do %' THEN regexp_replace(county_parish_verbatim, 'Sao Salvador Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Sebastiao Da %' THEN regexp_replace(county_parish_verbatim, 'Sao Sebastiao Da ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Sebastiao De %' THEN regexp_replace(county_parish_verbatim, 'Sao Sebastiao De ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Sebastiao Do %' THEN regexp_replace(county_parish_verbatim, 'Sao Sebastiao Do ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sao Vicente De Minas%' THEN regexp_replace(county_parish_verbatim, 'Sao Vicente De ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Tamazulapam del Espiritu Santo%' THEN regexp_replace(county_parish_verbatim, ' del Espiritu Santo', '', 'i')
WHEN county_parish_verbatim ILIKE 'Villa de San Diego de %' THEN regexp_replace(county_parish_verbatim, 'Villa de San Diego de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Villa de %' THEN regexp_replace(county_parish_verbatim, 'Villa de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Ville de %' THEN regexp_replace(county_parish_verbatim, 'Ville de ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Wahlkreis %' THEN regexp_replace(county_parish_verbatim, 'Wahlkreis ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Ward of %' THEN regexp_replace(county_parish_verbatim, 'Ward of ', '', 'i')
WHEN county_parish_verbatim ILIKE 'State of %' THEN regexp_replace(county_parish_verbatim, 'State of ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Union Territory of %' THEN regexp_replace(county_parish_verbatim, 'Union Territory of ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Wilaya de %' THEN regexp_replace(county_parish_verbatim, 'Wilaya de ', '', 'i')
ELSE NULL
END
WHERE job=:'job'
AND county_parish_verbatim IS NOT NULL AND county_parish_verbatim<>''
;

-- Prefixes without articles
UPDATE user_data
SET county_parish_verbatim_alt=
CASE
WHEN county_parish_verbatim ILIKE 'Amphoe%' THEN regexp_replace(county_parish_verbatim, 'Amphoe', '', 'i')
WHEN county_parish_verbatim ILIKE 'Arrondissement %' THEN regexp_replace(county_parish_verbatim, 'Arrondissement ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Bashkia%' THEN regexp_replace(county_parish_verbatim, 'Bashkia', '', 'i')
WHEN county_parish_verbatim ILIKE 'Bezirk%' THEN regexp_replace(county_parish_verbatim, 'Bezirk', '', 'i')
WHEN county_parish_verbatim ILIKE 'Canton%' THEN regexp_replace(county_parish_verbatim, 'Canton', '', 'i')
WHEN county_parish_verbatim ILIKE 'Concelho%' THEN regexp_replace(county_parish_verbatim, 'Concelho', '', 'i')
WHEN county_parish_verbatim ILIKE 'Changwat%' THEN regexp_replace(county_parish_verbatim, 'Changwat', '', 'i')
WHEN county_parish_verbatim ILIKE 'Circunscricao%' THEN regexp_replace(county_parish_verbatim, 'Circunscricao', '', 'i')
WHEN county_parish_verbatim ILIKE 'County %' THEN regexp_replace(county_parish_verbatim, 'County ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Comuna %' THEN regexp_replace(county_parish_verbatim, 'Comuna ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Departamento%' THEN regexp_replace(county_parish_verbatim, 'Departamento', '', 'i')
WHEN county_parish_verbatim ILIKE 'Departament%' THEN regexp_replace(county_parish_verbatim, 'Departament', '', 'i')
WHEN county_parish_verbatim ILIKE 'Departement%' THEN regexp_replace(county_parish_verbatim, 'Departement', '', 'i')
WHEN county_parish_verbatim ILIKE 'Distrito%' THEN regexp_replace(county_parish_verbatim, 'Distrito', '', 'i')
WHEN county_parish_verbatim ILIKE 'Estado%' THEN regexp_replace(county_parish_verbatim, 'Estado', '', 'i')
WHEN county_parish_verbatim ILIKE 'Gemeente %' THEN regexp_replace(county_parish_verbatim, 'Gemeente ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Gorod %' THEN regexp_replace(county_parish_verbatim, 'Gorod ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Gorodskoy okrug %' THEN regexp_replace(county_parish_verbatim, 'Gorodskoy okrug ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Gouvernorat%' THEN regexp_replace(county_parish_verbatim, 'Gouvernorat', '', 'i')
WHEN county_parish_verbatim ILIKE 'Grad %' THEN regexp_replace(county_parish_verbatim, 'Grad ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Horad %' THEN regexp_replace(county_parish_verbatim, 'Horad ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Huyen %' THEN regexp_replace(county_parish_verbatim, 'Huyen ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Kanton%' THEN regexp_replace(county_parish_verbatim, 'Kanton', '', 'i')
WHEN county_parish_verbatim ILIKE 'Kabupaten %' THEN regexp_replace(county_parish_verbatim, 'Kabupaten ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Kota Administrasi Jakarta %' THEN regexp_replace(county_parish_verbatim, 'Kota Administrasi Jakarta ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Kota %' THEN regexp_replace(county_parish_verbatim, 'Kota ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Liwa'' %' THEN regexp_replace(county_parish_verbatim, 'Liwa'' ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Markaz %' THEN regexp_replace(county_parish_verbatim, 'Markaz ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Muang %' THEN regexp_replace(county_parish_verbatim, 'Muang ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Mudiriyat %' THEN regexp_replace(county_parish_verbatim, 'Mudiriyat ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Municipio %' THEN regexp_replace(county_parish_verbatim, 'Municipio ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Municipiul %' THEN regexp_replace(county_parish_verbatim, 'Municipiul ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Nohiyai %' THEN regexp_replace(county_parish_verbatim, 'Nohiyai ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Nomarchia %' THEN regexp_replace(county_parish_verbatim, 'Nomarchia ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Nomos %' THEN regexp_replace(county_parish_verbatim, 'Nomos ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Obcina%' THEN regexp_replace(county_parish_verbatim, 'Obcina', '', 'i')
WHEN county_parish_verbatim ILIKE 'Obshtina %' THEN regexp_replace(county_parish_verbatim, 'Obshtina ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Opstina %' THEN regexp_replace(county_parish_verbatim, 'Opstina ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Okres %' THEN regexp_replace(county_parish_verbatim, 'Okres ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Oras %' THEN regexp_replace(county_parish_verbatim, 'Oras ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Parish%' THEN regexp_replace(county_parish_verbatim, 'Parish', '', 'i')
WHEN county_parish_verbatim ILIKE 'Politischer Bezirk %' THEN regexp_replace(county_parish_verbatim, 'Politischer Bezirk ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Powiat %' THEN regexp_replace(county_parish_verbatim, 'Powiat ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Prefecture %' THEN regexp_replace(county_parish_verbatim, 'Prefecture ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Principality%' THEN regexp_replace(county_parish_verbatim, 'Principality', '', 'i')
WHEN county_parish_verbatim ILIKE 'Province%' THEN regexp_replace(county_parish_verbatim, 'Province', '', 'i')
WHEN county_parish_verbatim ILIKE 'Provincia%' THEN regexp_replace(county_parish_verbatim, 'Provincia', '', 'i')
WHEN county_parish_verbatim ILIKE 'Provinsi%' THEN regexp_replace(county_parish_verbatim, 'Provinsi', '', 'i')
WHEN county_parish_verbatim ILIKE 'Qada'' %' THEN regexp_replace(county_parish_verbatim, 'Qada'' ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Qeza-i %' THEN regexp_replace(county_parish_verbatim, 'Qeza-i ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Quan %' THEN regexp_replace(county_parish_verbatim, 'Quan ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Region %' THEN regexp_replace(county_parish_verbatim, 'Region ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Regierungsbezirk %' THEN regexp_replace(county_parish_verbatim, 'Regierungsbezirk ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Rrethi i %' THEN regexp_replace(county_parish_verbatim, 'Rrethi i ', '', 'i')
WHEN county_parish_verbatim ILIKE 'State %' THEN regexp_replace(county_parish_verbatim, 'State ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Shahrestan-e %' THEN regexp_replace(county_parish_verbatim, 'Shahrestan-e ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Srok %' THEN regexp_replace(county_parish_verbatim, 'Srok ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Sveitarfelagid %' THEN regexp_replace(county_parish_verbatim, 'Sveitarfelagid ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Thanh Pho %' THEN regexp_replace(county_parish_verbatim, 'Thanh Pho ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Thi Xa %' THEN regexp_replace(county_parish_verbatim, 'Thi Xa ', '', 'i')
WHEN county_parish_verbatim ILIKE 'Union Territory%' THEN regexp_replace(county_parish_verbatim, 'Union Territory', '', 'i')
WHEN county_parish_verbatim ILIKE 'Wilaya%' THEN regexp_replace(county_parish_verbatim, 'Wilaya', '', 'i')
WHEN county_parish_verbatim ILIKE 'Tinh%' THEN regexp_replace(county_parish_verbatim, 'Tinh', '', 'i')
ELSE NULL
END
WHERE job=:'job'
AND county_parish_verbatim IS NOT NULL AND county_parish_verbatim<>''
AND (county_parish_verbatim_alt IS NULL OR county_parish_verbatim_alt='')
;


-- Suffixes
UPDATE user_data
SET county_parish_verbatim_alt=
CASE
WHEN county_parish_verbatim ILIKE '%  Administrativnyy Okrug' THEN regexp_replace(county_parish_verbatim, ' Administrativnyy Okrug', '', 'i')
WHEN county_parish_verbatim ILIKE '% Audany' THEN regexp_replace(county_parish_verbatim, ' Audany', '', 'i')
WHEN county_parish_verbatim ILIKE '% District' THEN regexp_replace(county_parish_verbatim, 'District', '', 'i')
WHEN county_parish_verbatim ILIKE '% County' THEN regexp_replace(county_parish_verbatim, ' County', '', 'i')
WHEN county_parish_verbatim ILIKE '% Parish' THEN regexp_replace(county_parish_verbatim, 'Parish', '', 'i')
WHEN county_parish_verbatim ILIKE '% Department' THEN regexp_replace(county_parish_verbatim, ' Department', '', 'i')
WHEN county_parish_verbatim ILIKE '% District' THEN regexp_replace(county_parish_verbatim, ' District', '', 'i')
WHEN county_parish_verbatim ILIKE '% Division' THEN regexp_replace(county_parish_verbatim, ' Division', '', 'i')
WHEN county_parish_verbatim ILIKE '% Municipality' THEN regexp_replace(county_parish_verbatim, 'Municipality', '', 'i')
WHEN county_parish_verbatim ILIKE '% Munitsip''alit''et''i' THEN regexp_replace(county_parish_verbatim, ' Munitsip''alit''et''i', '', 'i')
WHEN county_parish_verbatim ILIKE '% Mis''krada' THEN regexp_replace(county_parish_verbatim, 'Mis''krada', '', 'i')
WHEN county_parish_verbatim ILIKE '% Municipio' THEN regexp_replace(county_parish_verbatim, 'Municipio', '', 'i')
WHEN county_parish_verbatim ILIKE '% Province' THEN regexp_replace(county_parish_verbatim, ' Province', '', 'i')
WHEN county_parish_verbatim ILIKE '% pagasts' THEN regexp_replace(county_parish_verbatim, ' pagasts', '', 'i')
WHEN county_parish_verbatim ILIKE '% Qalasy' THEN regexp_replace(county_parish_verbatim, ' Qalasy', '', 'i')
WHEN county_parish_verbatim ILIKE '% Region' THEN regexp_replace(county_parish_verbatim, ' Region', '', 'i')
WHEN county_parish_verbatim ILIKE '% Rayon' THEN regexp_replace(county_parish_verbatim, ' Rayon', '', 'i')
WHEN county_parish_verbatim ILIKE '% Territory' THEN regexp_replace(county_parish_verbatim, 'Territory', '', 'i')
ELSE NULL
END
WHERE job=:'job'
AND county_parish_verbatim IS NOT NULL AND county_parish_verbatim<>''
AND (county_parish_verbatim_alt IS NULL OR county_parish_verbatim_alt='')
;

-- Trim whitespace
UPDATE user_data
SET county_parish_verbatim_alt=TRIM(county_parish_verbatim_alt)
WHERE job=:'job'
AND county_parish_verbatim_alt IS NOT NULL AND county_parish_verbatim_alt<>''
;

-- REstore errors
UPDATE user_data
SET county_parish_verbatim_alt=county_parish_verbatim
WHERE county_parish_verbatim LIKE 'Comuna 1%'
OR county_parish_verbatim LIKE 'Comuna 2%'
OR county_parish_verbatim LIKE 'Comuna 3%'
OR county_parish_verbatim LIKE 'Comuna 4%'
OR county_parish_verbatim LIKE 'Comuna 5%'
OR county_parish_verbatim LIKE 'Comuna 6%'
OR county_parish_verbatim LIKE 'Comuna 7%'
OR county_parish_verbatim LIKE 'Comuna 8%'
OR county_parish_verbatim LIKE 'Comuna 9%'
;
UPDATE user_data
SET county_parish_verbatim_alt=county_parish_verbatim
WHERE county_parish_verbatim='Quan 12'
;
UPDATE user_data
SET county_parish_verbatim_alt=county_parish_verbatim
WHERE county_parish_verbatim='San Cristobal De Casas'
;
UPDATE user_data
SET county_parish_verbatim_alt='San Jeronimo'
WHERE county_parish_verbatim='San Jeronimo Department'
;
UPDATE user_data
SET county_parish_verbatim_alt=county_parish_verbatim
WHERE county_parish_verbatim='San Sebastian del Oeste'
;
UPDATE user_data
SET county_parish_verbatim_alt=county_parish_verbatim
WHERE county_parish_verbatim IN (
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

