-- ------------------------------------------------------------------
-- Adds & populates column state_province_std in table state_province 
-- Contains plain ascii names minus any category modifiers
-- Order is CRITICAL!
-- ------------------------------------------------------------------

--
-- Table: state_province
--

ALTER TABLE state_province
ADD COLUMN state_province_std VARCHAR(100) DEFAULT NULL
;
UPDATE state_province
SET state_province_std=state_province_ascii
;

-- Prefixes including article 'de', 'of', etc.
UPDATE state_province
SET state_province_std=
CASE
WHEN state_province_std ILIKE 'Avtonomnyy Okrug%' THEN regexp_replace(state_province_std, 'Avtonomnyy Okrug', '', 'i')
WHEN state_province_std ILIKE 'Autonomous District%' THEN regexp_replace(state_province_std, 'Autonomous District', '', 'i')
WHEN state_province_std ILIKE 'Autonomous Region%' THEN regexp_replace(state_province_std, 'Autonomous Region', '', 'i')
WHEN state_province_std ILIKE 'Avtonomnaya Oblast''%' THEN regexp_replace(state_province_std, 'Avtonomnaya Oblast''', '', 'i')
WHEN state_province_std ILIKE 'Canton d''%' THEN regexp_replace(state_province_std, 'Canton d''', '', 'i')
WHEN state_province_std ILIKE 'Canton de%' THEN regexp_replace(state_province_std, 'Canton de', '', 'i')
WHEN state_province_std ILIKE 'Canton du%' THEN regexp_replace(state_province_std, 'Canton du', '', 'i')
WHEN state_province_std ILIKE 'Castello di%' THEN regexp_replace(state_province_std, 'Castello di', '', 'i')
WHEN state_province_std ILIKE 'Commune de%' THEN regexp_replace(state_province_std, 'Commune de', '', 'i')
WHEN state_province_std ILIKE 'Concelho dos%' THEN regexp_replace(state_province_std, 'Concelho dos', '', 'i')
WHEN state_province_std ILIKE 'Concelho do%' THEN regexp_replace(state_province_std, 'Concelho do', '', 'i')
WHEN state_province_std ILIKE 'Concelho da%' THEN regexp_replace(state_province_std, 'Concelho da', '', 'i')
WHEN state_province_std ILIKE 'Concelho de%' THEN regexp_replace(state_province_std, 'Concelho de', '', 'i')
WHEN state_province_std ILIKE 'Departement de l''%' THEN regexp_replace(state_province_std, 'Departement de l''', '', 'i')
WHEN state_province_std ILIKE 'Departamento del%' THEN regexp_replace(state_province_std, 'Departamento del', '', 'i')
WHEN state_province_std ILIKE 'Departamento de%' THEN regexp_replace(state_province_std, 'Departamento de', '', 'i')
WHEN state_province_std ILIKE 'Departament of%' THEN regexp_replace(state_province_std, 'Departament of', '', 'i')
WHEN state_province_std ILIKE 'Departement de%' THEN regexp_replace(state_province_std, 'Departement de', '', 'i')
WHEN state_province_std ILIKE 'Distrito Capital de%' THEN regexp_replace(state_province_std, 'Distrito Capital de', '', 'i')
WHEN state_province_std ILIKE 'Distrito del%' THEN regexp_replace(state_province_std, 'Distrito del', '', 'i')
WHEN state_province_std ILIKE 'Distrito da%' THEN regexp_replace(state_province_std, 'Distrito da', '', 'i')
WHEN state_province_std ILIKE 'Distrito do%' THEN regexp_replace(state_province_std, 'Distrito do', '', 'i')
WHEN state_province_std ILIKE 'Distrito de%' THEN regexp_replace(state_province_std, 'Distrito de', '', 'i')
WHEN state_province_std ILIKE 'Estado de%' THEN regexp_replace(state_province_std, 'Estado de', '', 'i')
WHEN state_province_std ILIKE 'Gouvernorat de%' THEN regexp_replace(state_province_std, 'Gouvernorat de', '', 'i')
WHEN state_province_std ILIKE 'Ile du %' THEN 
regexp_replace(state_province_std, 'Ile du ', '', 'i')
WHEN state_province_std ILIKE 'Ile %' THEN 
regexp_replace(state_province_std, 'Ile ', '', 'i')
WHEN state_province_std ILIKE 'Municipio Especial%' THEN regexp_replace(state_province_std, 'Municipio Especial', '', 'i')
WHEN state_province_std ILIKE 'Muhafazat ''%' THEN regexp_replace(state_province_std, 'Muhafazat ''', '', 'i')
WHEN state_province_std ILIKE 'Muhafazat ad %' THEN regexp_replace(state_province_std, 'Muhafazat ad ', '', 'i')
WHEN state_province_std ILIKE 'Muhafazat al %' THEN regexp_replace(state_province_std, 'Muhafazat al ', '', 'i')
WHEN state_province_std ILIKE 'Muhafazat `%' THEN regexp_replace(state_province_std, 'Muhafazat `', '', 'i')
WHEN state_province_std ILIKE 'Muhafazat ash ' THEN regexp_replace(state_province_std, 'Muhafazat ash ', '', 'i')
WHEN state_province_std ILIKE 'Muhafazat as %' THEN regexp_replace(state_province_std, 'Muhafazat as ', '', 'i')
WHEN state_province_std ILIKE 'Muhafazat at %' THEN regexp_replace(state_province_std, 'Muhafazat at ', '', 'i')
WHEN state_province_std ILIKE 'Ostan-ef%' THEN regexp_replace(state_province_std, 'Ostan-e', '', 'i')
WHEN state_province_std ILIKE 'Parish of%' THEN regexp_replace(state_province_std, 'Parish of', '', 'i')
WHEN state_province_std ILIKE 'Prefecture de la%' THEN regexp_replace(state_province_std, 'Prefecture de la', '', 'i')
WHEN state_province_std ILIKE 'Prefecture de%' THEN regexp_replace(state_province_std, 'Prefecture de', '', 'i')
WHEN state_province_std ILIKE 'Principality of%' THEN regexp_replace(state_province_std, 'Principality of', '', 'i')
WHEN state_province_std ILIKE 'Province de l''%' THEN regexp_replace(state_province_std, 'Province de l''', '', 'i')
WHEN state_province_std ILIKE 'Province of%' THEN regexp_replace(state_province_std, 'Province of', '', 'i')
WHEN state_province_std ILIKE 'Provincia del%' THEN regexp_replace(state_province_std, 'Provincia del', '', 'i')
WHEN state_province_std ILIKE 'Provincia des %' THEN regexp_replace(state_province_std, 'Provincia des ', '', 'i')
WHEN state_province_std ILIKE 'Provincia de%' THEN regexp_replace(state_province_std, 'Provincia de', '', 'i')
WHEN state_province_std ILIKE 'Province du%' THEN regexp_replace(state_province_std, 'Province du', '', 'i')
WHEN state_province_std ILIKE 'Province de%' THEN regexp_replace(state_province_std, 'Province de', '', 'i')
WHEN state_province_std ILIKE 'Qarku i%' THEN regexp_replace(state_province_std, 'Qarku i', '', 'i')
WHEN state_province_std ILIKE 'Region Metropolitana de%' THEN regexp_replace(state_province_std, 'Region Metropolitana de', '', 'i')
WHEN state_province_std ILIKE 'Regional District of%' THEN regexp_replace(state_province_std, 'Regional District of', '', 'i')
WHEN state_province_std ILIKE 'Regione Autonoma%' THEN regexp_replace(state_province_std, 'Regione Autonoma', '', 'i')
WHEN state_province_std ILIKE 'Region del%' THEN regexp_replace(state_province_std, 'Region del', '', 'i')
WHEN state_province_std ILIKE 'Region du%' THEN regexp_replace(state_province_std, 'Region du', '', 'i')
WHEN state_province_std ILIKE 'Region de%' THEN regexp_replace(state_province_std, 'Region de', '', 'i')
WHEN state_province_std ILIKE 'State of%' THEN regexp_replace(state_province_std, 'State of', '', 'i')
WHEN state_province_std ILIKE 'Sha''biyat al%' THEN regexp_replace(state_province_std, 'Sha''biyat al', '', 'i')
WHEN state_province_std ILIKE 'Sha''biyat an%' THEN regexp_replace(state_province_std, 'Sha''biyat an', '', 'i')
WHEN state_province_std ILIKE 'Sha''biyat az%' THEN regexp_replace(state_province_std, 'Sha''biyat az', '', 'i')
WHEN state_province_std ILIKE 'Sha''biyat%' THEN regexp_replace(state_province_std, 'Sha''biyat', '', 'i')
WHEN state_province_std ILIKE 'Union Territory of%' THEN regexp_replace(state_province_std, 'Union Territory of', '', 'i')
WHEN state_province_std ILIKE 'Wilayat-e%' THEN regexp_replace(state_province_std, 'Wilayat-e', '', 'i')
WHEN state_province_std ILIKE 'Wilaya du %' THEN regexp_replace(state_province_std, 'Wilaya du ', '', 'i')
WHEN state_province_std ILIKE 'Wilaya d''%' THEN regexp_replace(state_province_std, 'Wilaya d''', '', 'i')
WHEN state_province_std ILIKE 'Wilaya de%' THEN regexp_replace(state_province_std, 'Wilaya de', '', 'i')
ELSE state_province_std
END;

-- Prefixes without articles
UPDATE state_province
SET state_province_std=
CASE
WHEN state_province_std ILIKE 'Canton%' THEN regexp_replace(state_province_std, 'Canton', '', 'i')
WHEN state_province_std ILIKE 'Changwat%' THEN regexp_replace(state_province_std, 'Changwat', '', 'i')
WHEN state_province_std ILIKE 'Kanton%' THEN regexp_replace(state_province_std, 'Kanton', '', 'i')
WHEN state_province_std ILIKE 'Concelho%' THEN regexp_replace(state_province_std, 'Concelho', '', 'i')
WHEN state_province_std ILIKE 'Departamento%' THEN regexp_replace(state_province_std, 'Departamento', '', 'i')
WHEN state_province_std ILIKE 'Departament%' THEN regexp_replace(state_province_std, 'Departament', '', 'i')
WHEN state_province_std ILIKE 'Departement%' THEN regexp_replace(state_province_std, 'Departement', '', 'i')
WHEN state_province_std ILIKE 'Distrikt%' THEN regexp_replace(state_province_std, 'Distrikt', '', 'i')
WHEN state_province_std ILIKE 'Distrito%' AND state_province_std NOT LIKE 'Distrito Capital%' THEN regexp_replace(state_province_std, 'Distrito', '', 'i')
WHEN state_province_std ILIKE 'Eparchia%' THEN regexp_replace(state_province_std, 'Eparchia', '', 'i')
WHEN state_province_std ILIKE 'Estado%' THEN regexp_replace(state_province_std, 'Estado', '', 'i')
WHEN state_province_std ILIKE 'Gobolka%' THEN regexp_replace(state_province_std, 'Gobolka', '', 'i')
WHEN state_province_std ILIKE 'Gouvernorat%' THEN regexp_replace(state_province_std, 'Gouvernorat', '', 'i')
WHEN state_province_std ILIKE 'Judetul%' THEN 
regexp_replace(state_province_std, 'Judetul', '', 'i')
WHEN state_province_std ILIKE 'Mohafazat%' THEN 
regexp_replace(state_province_std, 'Mohafazat', '', 'i')
WHEN state_province_std ILIKE 'Muhafazat%' THEN 
regexp_replace(state_province_std, 'Muhafazat', '', 'i')
WHEN state_province_std ILIKE 'Obcina%' THEN 
regexp_replace(state_province_std, 'Obcina', '', 'i')
WHEN state_province_std ILIKE 'Oblast%' THEN regexp_replace(state_province_std, 'Oblast', '', 'i')
WHEN state_province_std ILIKE 'Opstina%' THEN regexp_replace(state_province_std, 'Opstina', '', 'i')
WHEN state_province_std ILIKE 'Parish%' THEN regexp_replace(state_province_std, 'Parish', '', 'i')
WHEN state_province_std ILIKE 'Prefecture%' THEN regexp_replace(state_province_std, 'Prefecture', '', 'i')
WHEN state_province_std ILIKE 'Principality%' THEN regexp_replace(state_province_std, 'Principality', '', 'i')
WHEN state_province_std ILIKE 'Provincie %' THEN regexp_replace(state_province_std, 'Provincie ', '', 'i')
WHEN state_province_std ILIKE 'Province%' THEN regexp_replace(state_province_std, 'Province', '', 'i')
WHEN state_province_std ILIKE 'Provincia%' THEN regexp_replace(state_province_std, 'Provincia', '', 'i')
WHEN state_province_std ILIKE 'Provinsi%' THEN regexp_replace(state_province_std, 'Provinsi', '', 'i')
WHEN state_province_std ILIKE 'Region%' THEN regexp_replace(state_province_std, 'Region', '', 'i')
WHEN state_province_std ILIKE 'Raionul%' THEN regexp_replace(state_province_std, 'Raionul', '', 'i')
WHEN state_province_std ILIKE 'Respublika%' THEN regexp_replace(state_province_std, 'Respublika', '', 'i')
WHEN state_province_std ILIKE 'State%' THEN regexp_replace(state_province_std, 'State', '', 'i')
WHEN state_province_std ILIKE 'Tinh%' THEN regexp_replace(state_province_std, 'Tinh', '', 'i')
WHEN state_province_std ILIKE 'Union Territory%' THEN regexp_replace(state_province_std, 'Union Territory', '', 'i')
WHEN state_province_std ILIKE 'Wilaya%' THEN regexp_replace(state_province_std, 'Wilaya', '', 'i')
WHEN state_province_std ILIKE 'Wojewodztwo%' THEN regexp_replace(state_province_std, 'Wojewodztwo', '', 'i')
ELSE state_province_std
END;

-- Suffixes
UPDATE state_province
SET state_province_std=
CASE
WHEN state_province_std ILIKE '% County' THEN regexp_replace(state_province_std, 'County', '', 'i')
WHEN state_province_std ILIKE '% Department' THEN regexp_replace(state_province_std, 'Department', '', 'i')
WHEN state_province_std ILIKE '% District' THEN regexp_replace(state_province_std, 'District', '', 'i')
WHEN state_province_std ILIKE '% Division' THEN regexp_replace(state_province_std, 'Division', '', 'i')
WHEN state_province_std ILIKE '% Governorate' THEN regexp_replace(state_province_std, 'Governorate', '', 'i')
WHEN state_province_std ILIKE '% Marz' THEN regexp_replace(state_province_std, 'Marz', '', 'i')
WHEN state_province_std ILIKE '% Municipality' THEN regexp_replace(state_province_std, 'Municipality', '', 'i')
WHEN state_province_std ILIKE '% Municipio' THEN regexp_replace(state_province_std, 'Municipio', '', 'i')
WHEN state_province_std ILIKE '% Novads' THEN regexp_replace(state_province_std, 'Novads', '', 'i')
WHEN state_province_std ILIKE '% Parish' THEN regexp_replace(state_province_std, ' Parish', '', 'i')
WHEN state_province_std ILIKE '% Oblast''' THEN regexp_replace(state_province_std, ' Oblast''', '', 'i')
WHEN state_province_std ILIKE '% Oblast' THEN regexp_replace(state_province_std, ' Oblast', '', 'i')
WHEN state_province_std ILIKE '% Province' THEN regexp_replace(state_province_std, 'Province', '', 'i')
WHEN state_province_std ILIKE '% Rayon' THEN regexp_replace(state_province_std, 'Rayon', '', 'i')
WHEN state_province_std ILIKE '% Region' THEN regexp_replace(state_province_std, 'Region', '', 'i')
WHEN state_province_std ILIKE '% State' THEN regexp_replace(state_province_std, 'State', '', 'i')
WHEN state_province_std ILIKE '% Territory' THEN regexp_replace(state_province_std, 'Territory', '', 'i')
ELSE state_province_std
END;

UPDATE state_province
SET state_province_std=TRIM(state_province_std)
;

-- Restore mistakes
UPDATE state_province
SET state_province_std='Al Batinah North Governorate'
WHERE state_province_ascii='Al Batinah North Governorate'
;
UPDATE state_province
SET state_province_std='Al Batinah South Governorate'
WHERE state_province_ascii='Al Batinah South Governorate'
;
UPDATE state_province
SET state_province_std='Al Bayda Governorate'
WHERE state_province_ascii='Al Bayda Governorate'
;
UPDATE state_province
SET state_province_std='Central District'
WHERE state_province_ascii='Central District'
;
UPDATE state_province
SET state_province_std='Central Division'
WHERE state_province_ascii='Central Division'
;
UPDATE state_province
SET state_province_std='Central Province '
WHERE state_province_ascii='Central Province '
;
UPDATE state_province
SET state_province_std='Central Region'
WHERE state_province_ascii='Central Region'
;
UPDATE state_province
SET state_province_std='Centre Region'
WHERE state_province_ascii='Centre Region'
;
UPDATE state_province
SET state_province_std='Departamento Central'
WHERE state_province_ascii='Departamento Central'
;
UPDATE state_province
SET state_province_std='Departement du Nord-Est'
WHERE state_province_ascii='Departement du Nord-Est'
;
UPDATE state_province
SET state_province_std='Eastern District'
WHERE state_province_ascii='Eastern District'
;
UPDATE state_province
SET state_province_std='Eastern Division'
WHERE state_province_ascii='Eastern Division'
;
UPDATE state_province
SET state_province_std='Eastern Province'
WHERE state_province_ascii='Eastern Province'
;
UPDATE state_province
SET state_province_std='Eastern Region'
WHERE state_province_ascii='Eastern Region'
;
UPDATE state_province
SET state_province_std='Far North Region'
WHERE state_province_ascii='Far North Region'
;
UPDATE state_province
SET state_province_std='Federal Capital Territory'
WHERE state_province_ascii='Federal Capital Territory'
;
UPDATE state_province
SET state_province_std='Federal District'
WHERE state_province_ascii='Federal District'
;
UPDATE state_province
SET state_province_std='Midway Islands'
WHERE state_province_ascii='Midway Islands'
;
UPDATE state_province
SET state_province_std='National Capital District'
WHERE state_province_ascii='National Capital District'
;
UPDATE state_province
SET state_province_std='National Capital Region'
WHERE state_province_ascii='National Capital Region'
;
UPDATE state_province
SET state_province_std='North Central Province '
WHERE state_province_ascii='North Central Province '
;
UPDATE state_province
SET state_province_std='North East District'
WHERE state_province_ascii='North East District'
;
UPDATE state_province
SET state_province_std='Northern District'
WHERE state_province_ascii='Northern District'
;
UPDATE state_province
SET state_province_std='Northern Division'
WHERE state_province_ascii='Northern Division'
;
UPDATE state_province
SET state_province_std='Northern Governorate'
WHERE state_province_ascii='Northern Governorate'
;
UPDATE state_province
SET state_province_std='Northern Province'
WHERE state_province_ascii='Northern Province'
;
UPDATE state_province
SET state_province_std='Northern Region'
WHERE state_province_ascii='Northern Region'
;
UPDATE state_province
SET state_province_std='Northern Territory'
WHERE state_province_ascii='Northern Territory'
;
UPDATE state_province
SET state_province_std='North Region'
WHERE state_province_ascii='North Region'
;
UPDATE state_province
SET state_province_std='North West District'
WHERE state_province_ascii='North West District'
;
UPDATE state_province
SET state_province_std='North Western Province'
WHERE state_province_ascii='North Western Province'
;
UPDATE state_province
SET state_province_std='North-Western Province'
WHERE state_province_ascii='North-Western Province'
;
UPDATE state_province
SET state_province_std='North-West Region'
WHERE state_province_ascii='North-West Region'
;
UPDATE state_province
SET state_province_std='Northern Governorate'
WHERE state_province_ascii='Northern Governorate'
;
UPDATE state_province
SET state_province_std='Northern Division'
WHERE state_province_ascii='Northern Division'
;
UPDATE state_province
SET state_province_std='Northern Governorate'
WHERE state_province_ascii='Northern Governorate'
;
UPDATE state_province
SET state_province_std='North East District'
WHERE state_province_ascii='North East District'
;
UPDATE state_province
SET state_province_std='North Central Province'
WHERE state_province_ascii='North Central Province'
;
UPDATE state_province
SET state_province_std='West Region'
WHERE state_province_ascii='West Region'
;
UPDATE state_province
SET state_province_std='Western Region'
WHERE state_province_ascii='Western Region'
;
UPDATE state_province
SET state_province_std='Western Province'
WHERE state_province_ascii='Western Province'
;
UPDATE state_province
SET state_province_std='Southern Nations, Nationalities, and People''s Region'
WHERE state_province_ascii='Southern Nations, Nationalities, and People''s Region'
;
UPDATE state_province
SET state_province_std='Red Sea Governorate'
WHERE state_province_ascii='Red Sea Governorate'
;

CREATE INDEX state_province_state_province_std ON state_province (state_province_std);
CREATE INDEX state_province_state_province_std_ci_idx ON state_province USING btree (LOWER(state_province_std));


