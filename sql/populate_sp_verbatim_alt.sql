-- ------------------------------------------------------------
--  Populates column state_province_verbatim_alt
--
-- = state_province_verbatim stripped of categorical identifiers
-- such as "State", "Department", "Departamento de", 
-- "Municipio de", etc.
--
-- Requires parameter: :'job'

-- ------------------------------------------------------------

-- Prefixes including article 'de', 'of', etc.
UPDATE user_data
SET state_province_verbatim_alt=
CASE
WHEN state_province_verbatim ILIKE 'Avtonomnyy Okrug%' THEN regexp_replace(state_province_verbatim, 'Avtonomnyy Okrug', '', 'i')
WHEN state_province_verbatim ILIKE 'Autonomous District%' THEN regexp_replace(state_province_verbatim, 'Autonomous District', '', 'i')
WHEN state_province_verbatim ILIKE 'Autonomous Region%' THEN regexp_replace(state_province_verbatim, 'Autonomous Region', '', 'i')
WHEN state_province_verbatim ILIKE 'Avtonomnaya Oblast''%' THEN regexp_replace(state_province_verbatim, 'Avtonomnaya Oblast''', '', 'i')
WHEN state_province_verbatim ILIKE 'Canton d''%' THEN regexp_replace(state_province_verbatim, 'Canton d''', '', 'i')
WHEN state_province_verbatim ILIKE 'Canton de%' THEN regexp_replace(state_province_verbatim, 'Canton de', '', 'i')
WHEN state_province_verbatim ILIKE 'Canton du%' THEN regexp_replace(state_province_verbatim, 'Canton du', '', 'i')
WHEN state_province_verbatim ILIKE 'Castello di%' THEN regexp_replace(state_province_verbatim, 'Castello di', '', 'i')
WHEN state_province_verbatim ILIKE 'Commune de%' THEN regexp_replace(state_province_verbatim, 'Commune de', '', 'i')
WHEN state_province_verbatim ILIKE 'Concelho dos%' THEN regexp_replace(state_province_verbatim, 'Concelho dos', '', 'i')
WHEN state_province_verbatim ILIKE 'Concelho do%' THEN regexp_replace(state_province_verbatim, 'Concelho do', '', 'i')
WHEN state_province_verbatim ILIKE 'Concelho da%' THEN regexp_replace(state_province_verbatim, 'Concelho da', '', 'i')
WHEN state_province_verbatim ILIKE 'Concelho de%' THEN regexp_replace(state_province_verbatim, 'Concelho de', '', 'i')
WHEN state_province_verbatim ILIKE 'Departement de l''%' THEN regexp_replace(state_province_verbatim, 'Departement de l''', '', 'i')
WHEN state_province_verbatim ILIKE 'Departamento del%' THEN regexp_replace(state_province_verbatim, 'Departamento del', '', 'i')
WHEN state_province_verbatim ILIKE 'Departamento de%' THEN regexp_replace(state_province_verbatim, 'Departamento de', '', 'i')
WHEN state_province_verbatim ILIKE 'Departament of%' THEN regexp_replace(state_province_verbatim, 'Departament of', '', 'i')
WHEN state_province_verbatim ILIKE 'Departement de%' THEN regexp_replace(state_province_verbatim, 'Departement de', '', 'i')
WHEN state_province_verbatim ILIKE 'Distrito Capital de%' THEN regexp_replace(state_province_verbatim, 'Distrito Capital de', '', 'i')
WHEN state_province_verbatim ILIKE 'Distrito del%' THEN regexp_replace(state_province_verbatim, 'Distrito del', '', 'i')
WHEN state_province_verbatim ILIKE 'Distrito da%' THEN regexp_replace(state_province_verbatim, 'Distrito da', '', 'i')
WHEN state_province_verbatim ILIKE 'Distrito do%' THEN regexp_replace(state_province_verbatim, 'Distrito do', '', 'i')
WHEN state_province_verbatim ILIKE 'Distrito de%' THEN regexp_replace(state_province_verbatim, 'Distrito de', '', 'i')
WHEN state_province_verbatim ILIKE 'Estado de%' THEN regexp_replace(state_province_verbatim, 'Estado de', '', 'i')
WHEN state_province_verbatim ILIKE 'Gouvernorat de%' THEN regexp_replace(state_province_verbatim, 'Gouvernorat de', '', 'i')
WHEN state_province_verbatim ILIKE 'Ile du %' THEN 
regexp_replace(state_province_verbatim, 'Ile du ', '', 'i')
WHEN state_province_verbatim ILIKE 'Ile %' THEN 
regexp_replace(state_province_verbatim, 'Ile ', '', 'i')
WHEN state_province_verbatim ILIKE 'Municipio Especial%' THEN regexp_replace(state_province_verbatim, 'Municipio Especial', '', 'i')
WHEN state_province_verbatim ILIKE 'Muhafazat ''%' THEN regexp_replace(state_province_verbatim, 'Muhafazat ''', '', 'i')
WHEN state_province_verbatim ILIKE 'Muhafazat ad %' THEN regexp_replace(state_province_verbatim, 'Muhafazat ad ', '', 'i')
WHEN state_province_verbatim ILIKE 'Muhafazat al %' THEN regexp_replace(state_province_verbatim, 'Muhafazat al ', '', 'i')
WHEN state_province_verbatim ILIKE 'Muhafazat `%' THEN regexp_replace(state_province_verbatim, 'Muhafazat `', '', 'i')
WHEN state_province_verbatim ILIKE 'Muhafazat ash ' THEN regexp_replace(state_province_verbatim, 'Muhafazat ash ', '', 'i')
WHEN state_province_verbatim ILIKE 'Muhafazat as %' THEN regexp_replace(state_province_verbatim, 'Muhafazat as ', '', 'i')
WHEN state_province_verbatim ILIKE 'Muhafazat at %' THEN regexp_replace(state_province_verbatim, 'Muhafazat at ', '', 'i')
WHEN state_province_verbatim ILIKE 'Ostan-ef%' THEN regexp_replace(state_province_verbatim, 'Ostan-e', '', 'i')
WHEN state_province_verbatim ILIKE 'Parish of%' THEN regexp_replace(state_province_verbatim, 'Parish of', '', 'i')
WHEN state_province_verbatim ILIKE 'Prefecture de la%' THEN regexp_replace(state_province_verbatim, 'Prefecture de la', '', 'i')
WHEN state_province_verbatim ILIKE 'Prefecture de%' THEN regexp_replace(state_province_verbatim, 'Prefecture de', '', 'i')
WHEN state_province_verbatim ILIKE 'Principality of%' THEN regexp_replace(state_province_verbatim, 'Principality of', '', 'i')
WHEN state_province_verbatim ILIKE 'Province de l''%' THEN regexp_replace(state_province_verbatim, 'Province de l''', '', 'i')
WHEN state_province_verbatim ILIKE 'Province of%' THEN regexp_replace(state_province_verbatim, 'Province of', '', 'i')
WHEN state_province_verbatim ILIKE 'Provincia del%' THEN regexp_replace(state_province_verbatim, 'Provincia del', '', 'i')
WHEN state_province_verbatim ILIKE 'Provincia des %' THEN regexp_replace(state_province_verbatim, 'Provincia des ', '', 'i')
WHEN state_province_verbatim ILIKE 'Provincia de%' THEN regexp_replace(state_province_verbatim, 'Provincia de', '', 'i')
WHEN state_province_verbatim ILIKE 'Province du%' THEN regexp_replace(state_province_verbatim, 'Province du', '', 'i')
WHEN state_province_verbatim ILIKE 'Province de%' THEN regexp_replace(state_province_verbatim, 'Province de', '', 'i')
WHEN state_province_verbatim ILIKE 'Qarku i%' THEN regexp_replace(state_province_verbatim, 'Qarku i', '', 'i')
WHEN state_province_verbatim ILIKE 'Region Metropolitana de%' THEN regexp_replace(state_province_verbatim, 'Region Metropolitana de', '', 'i')
WHEN state_province_verbatim ILIKE 'Regional District of%' THEN regexp_replace(state_province_verbatim, 'Regional District of', '', 'i')
WHEN state_province_verbatim ILIKE 'Regione Autonoma%' THEN regexp_replace(state_province_verbatim, 'Regione Autonoma', '', 'i')
WHEN state_province_verbatim ILIKE 'Region del%' THEN regexp_replace(state_province_verbatim, 'Region del', '', 'i')
WHEN state_province_verbatim ILIKE 'Region du%' THEN regexp_replace(state_province_verbatim, 'Region du', '', 'i')
WHEN state_province_verbatim ILIKE 'Region de%' THEN regexp_replace(state_province_verbatim, 'Region de', '', 'i')
WHEN state_province_verbatim ILIKE 'State of%' THEN regexp_replace(state_province_verbatim, 'State of', '', 'i')
WHEN state_province_verbatim ILIKE 'Sha''biyat al%' THEN regexp_replace(state_province_verbatim, 'Sha''biyat al', '', 'i')
WHEN state_province_verbatim ILIKE 'Sha''biyat an%' THEN regexp_replace(state_province_verbatim, 'Sha''biyat an', '', 'i')
WHEN state_province_verbatim ILIKE 'Sha''biyat az%' THEN regexp_replace(state_province_verbatim, 'Sha''biyat az', '', 'i')
WHEN state_province_verbatim ILIKE 'Sha''biyat%' THEN regexp_replace(state_province_verbatim, 'Sha''biyat', '', 'i')
WHEN state_province_verbatim ILIKE 'Union Territory of%' THEN regexp_replace(state_province_verbatim, 'Union Territory of', '', 'i')
WHEN state_province_verbatim ILIKE 'Wilayat-e%' THEN regexp_replace(state_province_verbatim, 'Wilayat-e', '', 'i')
WHEN state_province_verbatim ILIKE 'Wilaya du %' THEN regexp_replace(state_province_verbatim, 'Wilaya du ', '', 'i')
WHEN state_province_verbatim ILIKE 'Wilaya d''%' THEN regexp_replace(state_province_verbatim, 'Wilaya d''', '', 'i')
WHEN state_province_verbatim ILIKE 'Wilaya de%' THEN regexp_replace(state_province_verbatim, 'Wilaya de', '', 'i')
ELSE NULL
END
WHERE job=:'job'
AND state_province_verbatim IS NOT NULL AND state_province_verbatim<>''
;

-- Prefixes without articles
UPDATE user_data
SET state_province_verbatim_alt=
CASE
WHEN state_province_verbatim ILIKE 'Canton%' THEN regexp_replace(state_province_verbatim, 'Canton', '', 'i')
WHEN state_province_verbatim ILIKE 'Changwat%' THEN regexp_replace(state_province_verbatim, 'Changwat', '', 'i')
WHEN state_province_verbatim ILIKE 'Kanton%' THEN regexp_replace(state_province_verbatim, 'Kanton', '', 'i')
WHEN state_province_verbatim ILIKE 'Concelho%' THEN regexp_replace(state_province_verbatim, 'Concelho', '', 'i')
WHEN state_province_verbatim ILIKE 'Departamento%' THEN regexp_replace(state_province_verbatim, 'Departamento', '', 'i')
WHEN state_province_verbatim ILIKE 'Departament%' THEN regexp_replace(state_province_verbatim, 'Departament', '', 'i')
WHEN state_province_verbatim ILIKE 'Departement%' THEN regexp_replace(state_province_verbatim, 'Departement', '', 'i')
WHEN state_province_verbatim ILIKE 'Distrikt%' THEN regexp_replace(state_province_verbatim, 'Distrikt', '', 'i')
WHEN state_province_verbatim ILIKE 'Distrito%' AND state_province_verbatim NOT LIKE 'Distrito Capital%' THEN regexp_replace(state_province_verbatim, 'Distrito', '', 'i')
WHEN state_province_verbatim ILIKE 'Eparchia%' THEN regexp_replace(state_province_verbatim, 'Eparchia', '', 'i')
WHEN state_province_verbatim ILIKE 'Estado%' THEN regexp_replace(state_province_verbatim, 'Estado', '', 'i')
WHEN state_province_verbatim ILIKE 'Gobolka%' THEN regexp_replace(state_province_verbatim, 'Gobolka', '', 'i')
WHEN state_province_verbatim ILIKE 'Gouvernorat%' THEN regexp_replace(state_province_verbatim, 'Gouvernorat', '', 'i')
WHEN state_province_verbatim ILIKE 'Judetul%' THEN 
regexp_replace(state_province_verbatim, 'Judetul', '', 'i')
WHEN state_province_verbatim ILIKE 'Mohafazat%' THEN 
regexp_replace(state_province_verbatim, 'Mohafazat', '', 'i')
WHEN state_province_verbatim ILIKE 'Muhafazat%' THEN 
regexp_replace(state_province_verbatim, 'Muhafazat', '', 'i')
WHEN state_province_verbatim ILIKE 'Obcina%' THEN 
regexp_replace(state_province_verbatim, 'Obcina', '', 'i')
WHEN state_province_verbatim ILIKE 'Oblast%' THEN regexp_replace(state_province_verbatim, 'Oblast', '', 'i')
WHEN state_province_verbatim ILIKE 'Opstina%' THEN regexp_replace(state_province_verbatim, 'Opstina', '', 'i')
WHEN state_province_verbatim ILIKE 'Parish%' THEN regexp_replace(state_province_verbatim, 'Parish', '', 'i')
WHEN state_province_verbatim ILIKE 'Prefecture%' THEN regexp_replace(state_province_verbatim, 'Prefecture', '', 'i')
WHEN state_province_verbatim ILIKE 'Principality%' THEN regexp_replace(state_province_verbatim, 'Principality', '', 'i')
WHEN state_province_verbatim ILIKE 'Provincie %' THEN regexp_replace(state_province_verbatim, 'Provincie ', '', 'i')
WHEN state_province_verbatim ILIKE 'Province%' THEN regexp_replace(state_province_verbatim, 'Province', '', 'i')
WHEN state_province_verbatim ILIKE 'Provincia%' THEN regexp_replace(state_province_verbatim, 'Provincia', '', 'i')
WHEN state_province_verbatim ILIKE 'Provinsi%' THEN regexp_replace(state_province_verbatim, 'Provinsi', '', 'i')
WHEN state_province_verbatim ILIKE 'Region%' THEN regexp_replace(state_province_verbatim, 'Region', '', 'i')
WHEN state_province_verbatim ILIKE 'Raionul%' THEN regexp_replace(state_province_verbatim, 'Raionul', '', 'i')
WHEN state_province_verbatim ILIKE 'Respublika%' THEN regexp_replace(state_province_verbatim, 'Respublika', '', 'i')
WHEN state_province_verbatim ILIKE 'State%' THEN regexp_replace(state_province_verbatim, 'State', '', 'i')
WHEN state_province_verbatim ILIKE 'Tinh%' THEN regexp_replace(state_province_verbatim, 'Tinh', '', 'i')
WHEN state_province_verbatim ILIKE 'Union Territory%' THEN regexp_replace(state_province_verbatim, 'Union Territory', '', 'i')
WHEN state_province_verbatim ILIKE 'Wilaya%' THEN regexp_replace(state_province_verbatim, 'Wilaya', '', 'i')
WHEN state_province_verbatim ILIKE 'Wojewodztwo%' THEN regexp_replace(state_province_verbatim, 'Wojewodztwo', '', 'i')
ELSE NULL
END
WHERE job=:'job'
AND state_province_verbatim IS NOT NULL AND state_province_verbatim<>''
AND (state_province_verbatim_alt IS NULL OR state_province_verbatim_alt='')
;

-- Suffixes
UPDATE user_data
SET state_province_verbatim_alt=
CASE
WHEN state_province_verbatim ILIKE '% County' THEN regexp_replace(state_province_verbatim, 'County', '', 'i')
WHEN state_province_verbatim ILIKE '% Department' THEN regexp_replace(state_province_verbatim, 'Department', '', 'i')
WHEN state_province_verbatim ILIKE '% District' THEN regexp_replace(state_province_verbatim, 'District', '', 'i')
WHEN state_province_verbatim ILIKE '% Division' THEN regexp_replace(state_province_verbatim, 'Division', '', 'i')
WHEN state_province_verbatim ILIKE '% Governorate' THEN regexp_replace(state_province_verbatim, 'Governorate', '', 'i')
WHEN state_province_verbatim ILIKE '% Marz' THEN regexp_replace(state_province_verbatim, 'Marz', '', 'i')
WHEN state_province_verbatim ILIKE '% Municipality' THEN regexp_replace(state_province_verbatim, 'Municipality', '', 'i')
WHEN state_province_verbatim ILIKE '% Municipio' THEN regexp_replace(state_province_verbatim, 'Municipio', '', 'i')
WHEN state_province_verbatim ILIKE '% Novads' THEN regexp_replace(state_province_verbatim, 'Novads', '', 'i')
WHEN state_province_verbatim ILIKE '% Parish' THEN regexp_replace(state_province_verbatim, ' Parish', '', 'i')
WHEN state_province_verbatim ILIKE '% Oblast''' THEN regexp_replace(state_province_verbatim, ' Oblast''', '', 'i')
WHEN state_province_verbatim ILIKE '% Oblast' THEN regexp_replace(state_province_verbatim, ' Oblast', '', 'i')
WHEN state_province_verbatim ILIKE '% Province' THEN regexp_replace(state_province_verbatim, 'Province', '', 'i')
WHEN state_province_verbatim ILIKE '% Rayon' THEN regexp_replace(state_province_verbatim, 'Rayon', '', 'i')
WHEN state_province_verbatim ILIKE '% Region' THEN regexp_replace(state_province_verbatim, 'Region', '', 'i')
WHEN state_province_verbatim ILIKE '% State' THEN regexp_replace(state_province_verbatim, 'State', '', 'i')
WHEN state_province_verbatim ILIKE '% Territory' THEN regexp_replace(state_province_verbatim, 'Territory', '', 'i')
ELSE NULL
END
WHERE job=:'job'
AND state_province_verbatim IS NOT NULL AND state_province_verbatim<>''
AND (state_province_verbatim_alt IS NULL OR state_province_verbatim_alt='')
;

UPDATE user_data
SET state_province_verbatim_alt=TRIM(state_province_verbatim_alt)
WHERE job=:'job'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
;


-- Restore mistakes
UPDATE user_data
SET state_province_verbatim_alt='Al Batinah North Governorate'
WHERE state_province_verbatim='Al Batinah North Governorate'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Al Batinah South Governorate'
WHERE state_province_verbatim='Al Batinah South Governorate'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Al Bayda Governorate'
WHERE state_province_verbatim='Al Bayda Governorate'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Central District'
WHERE state_province_verbatim='Central District'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Central Division'
WHERE state_province_verbatim='Central Division'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Central Province '
WHERE state_province_verbatim='Central Province '
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Central Region'
WHERE state_province_verbatim='Central Region'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Centre Region'
WHERE state_province_verbatim='Centre Region'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Departamento Central'
WHERE state_province_verbatim='Departamento Central'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Departement du Nord-Est'
WHERE state_province_verbatim='Departement du Nord-Est'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Eastern District'
WHERE state_province_verbatim='Eastern District'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Eastern Division'
WHERE state_province_verbatim='Eastern Division'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Eastern Province'
WHERE state_province_verbatim='Eastern Province'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Eastern Region'
WHERE state_province_verbatim='Eastern Region'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Far North Region'
WHERE state_province_verbatim='Far North Region'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Federal Capital Territory'
WHERE state_province_verbatim='Federal Capital Territory'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Federal District'
WHERE state_province_verbatim='Federal District'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Midway Islands'
WHERE state_province_verbatim='Midway Islands'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='National Capital District'
WHERE state_province_verbatim='National Capital District'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='National Capital Region'
WHERE state_province_verbatim='National Capital Region'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='North Central Province '
WHERE state_province_verbatim='North Central Province '
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='North East District'
WHERE state_province_verbatim='North East District'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Northern District'
WHERE state_province_verbatim='Northern District'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Northern Division'
WHERE state_province_verbatim='Northern Division'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Northern Governorate'
WHERE state_province_verbatim='Northern Governorate'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Northern Province'
WHERE state_province_verbatim='Northern Province'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Northern Region'
WHERE state_province_verbatim='Northern Region'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Northern Territory'
WHERE state_province_verbatim='Northern Territory'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='North Region'
WHERE state_province_verbatim='North Region'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='North West District'
WHERE state_province_verbatim='North West District'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='North Western Province'
WHERE state_province_verbatim='North Western Province'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='North-Western Province'
WHERE state_province_verbatim='North-Western Province'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='North-West Region'
WHERE state_province_verbatim='North-West Region'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Northern Governorate'
WHERE state_province_verbatim='Northern Governorate'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Northern Division'
WHERE state_province_verbatim='Northern Division'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Northern Governorate'
WHERE state_province_verbatim='Northern Governorate'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='North East District'
WHERE state_province_verbatim='North East District'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='North Central Province'
WHERE state_province_verbatim='North Central Province'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='West Region'
WHERE state_province_verbatim='West Region'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Western Region'
WHERE state_province_verbatim='Western Region'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Western Province'
WHERE state_province_verbatim='Western Province'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Southern Nations, Nationalities, and People''s Region'
WHERE state_province_verbatim='Southern Nations, Nationalities, and People''s Region'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;

UPDATE user_data
SET state_province_verbatim_alt='Red Sea Governorate'
WHERE state_province_verbatim='Red Sea Governorate'
AND state_province_verbatim_alt IS NOT NULL AND state_province_verbatim_alt<>''
AND job=:'job'
;
