-- ------------------------------------------------------------------
-- Adds & populates column state_province_std in table state_province 
-- Contains plain ascii names minus any category modifiers
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
WHEN state_province_std LIKE 'Canton de%' THEN REPLACE(state_province_std, 'Canton de', '')
WHEN state_province_std LIKE 'Castello di%' THEN REPLACE(state_province_std, 'Castello di', '')
WHEN state_province_std LIKE 'Commune de%' THEN REPLACE(state_province_std, 'Commune de', '')
WHEN state_province_std LIKE 'Concelho do%' THEN REPLACE(state_province_std, 'Concelho do', '')
WHEN state_province_std LIKE 'Concelho da%' THEN REPLACE(state_province_std, 'Concelho da', '')
WHEN state_province_std LIKE 'Concelho de%' THEN REPLACE(state_province_std, 'Concelho de', '')
WHEN state_province_std LIKE 'Departamento del%' THEN REPLACE(state_province_std, 'Departamento del', '')
WHEN state_province_std LIKE 'Departamento de%' THEN REPLACE(state_province_std, 'Departamento de', '')
WHEN state_province_std LIKE 'Departament of%' THEN REPLACE(state_province_std, 'Departament of', '')
WHEN state_province_std LIKE 'Departement de%' THEN REPLACE(state_province_std, 'Departement de', '')
WHEN state_province_std LIKE 'Distrito del%' THEN REPLACE(state_province_std, 'Distrito del', '')
WHEN state_province_std LIKE 'Distrito da%' THEN REPLACE(state_province_std, 'Distrito da', '')
WHEN state_province_std LIKE 'Distrito do%' THEN REPLACE(state_province_std, 'Distrito do', '')
WHEN state_province_std LIKE 'Distrito de%' THEN REPLACE(state_province_std, 'Distrito de', '')
WHEN state_province_std LIKE 'Estado de%' THEN REPLACE(state_province_std, 'Estado de', '')
WHEN state_province_std LIKE 'Gouvernorat de%' THEN REPLACE(state_province_std, 'Gouvernorat de', '')
WHEN state_province_std LIKE 'Municipio Especial%' THEN REPLACE(state_province_std, 'Municipio Especial', '')
WHEN state_province_std LIKE 'Parish of%' THEN REPLACE(state_province_std, 'Parish of', '')
WHEN state_province_std LIKE 'Prefecture de la%' THEN REPLACE(state_province_std, 'Prefecture de la', '')
WHEN state_province_std LIKE 'Prefecture de%' THEN REPLACE(state_province_std, 'Prefecture de', '')
WHEN state_province_std LIKE 'Principality of%' THEN REPLACE(state_province_std, 'Principality of', '')
WHEN state_province_std LIKE 'Province of%' THEN REPLACE(state_province_std, 'Province of', '')
WHEN state_province_std LIKE 'Provincia del%' THEN REPLACE(state_province_std, 'Provincia del', '')
WHEN state_province_std LIKE 'Provincia de%' THEN REPLACE(state_province_std, 'Provincia de', '')
WHEN state_province_std LIKE 'Province du%' THEN REPLACE(state_province_std, 'Province du', '')
WHEN state_province_std LIKE 'Province de%' THEN REPLACE(state_province_std, 'Province de', '')
WHEN state_province_std LIKE 'Qarku i%' THEN REPLACE(state_province_std, 'Qarku i', '')
WHEN state_province_std LIKE 'Region del%' THEN REPLACE(state_province_std, 'Region del', '')
WHEN state_province_std LIKE 'Region du%' THEN REPLACE(state_province_std, 'Region du', '')
WHEN state_province_std LIKE 'Region de%' THEN REPLACE(state_province_std, 'Region de', '')
WHEN state_province_std LIKE 'Region de%' THEN REPLACE(state_province_std, 'Region de', '')
WHEN state_province_std LIKE 'State of%' THEN REPLACE(state_province_std, 'State of', '')
WHEN state_province_std LIKE 'Union Territory of%' THEN REPLACE(state_province_std, 'Union Territory of', '')
WHEN state_province_std LIKE 'Wilaya de%' THEN REPLACE(state_province_std, 'Wilaya de', '')
ELSE state_province_std
END;

-- Prefixes without articles
UPDATE state_province
SET state_province_std=
CASE
WHEN state_province_std LIKE 'Canton%' THEN REPLACE(state_province_std, 'Canton', '')
WHEN state_province_std LIKE 'Kanton%' THEN REPLACE(state_province_std, 'Kanton', '')
WHEN state_province_std LIKE 'Concelho%' THEN REPLACE(state_province_std, 'Concelho', '')
WHEN state_province_std LIKE 'Departamento%' THEN REPLACE(state_province_std, 'Departamento', '')
WHEN state_province_std LIKE 'Departament%' THEN REPLACE(state_province_std, 'Departament', '')
WHEN state_province_std LIKE 'Departement%' THEN REPLACE(state_province_std, 'Departement', '')
WHEN state_province_std LIKE 'Distrito%' THEN REPLACE(state_province_std, 'Distrito', '')
WHEN state_province_std LIKE 'Estado%' THEN REPLACE(state_province_std, 'Estado', '')
WHEN state_province_std LIKE 'Gouvernorat%' THEN REPLACE(state_province_std, 'Gouvernorat', '')
WHEN state_province_std LIKE 'Parish%' THEN REPLACE(state_province_std, 'Parish', '')
WHEN state_province_std LIKE 'Prefecture%' THEN REPLACE(state_province_std, 'Prefecture', '')
WHEN state_province_std LIKE 'Principality%' THEN REPLACE(state_province_std, 'Principality', '')
WHEN state_province_std LIKE 'Province%' THEN REPLACE(state_province_std, 'Province', '')
WHEN state_province_std LIKE 'Provincia%' THEN REPLACE(state_province_std, 'Provincia', '')
WHEN state_province_std LIKE 'Provinsi%' THEN REPLACE(state_province_std, 'Provinsi', '')
WHEN state_province_std LIKE 'Region%' THEN REPLACE(state_province_std, 'Region', '')
WHEN state_province_std LIKE 'State%' THEN REPLACE(state_province_std, 'State', '')
WHEN state_province_std LIKE 'Union Territory%' THEN REPLACE(state_province_std, 'Union Territory', '')
WHEN state_province_std LIKE 'Wilaya%' THEN REPLACE(state_province_std, 'Wilaya', '')
WHEN state_province_std LIKE 'Tinh%' THEN REPLACE(state_province_std, 'Tinh', '')
WHEN state_province_std LIKE 'Changwat%' THEN REPLACE(state_province_std, 'Changwat', '')
WHEN state_province_std LIKE 'ChanObcinagwat%' THEN REPLACE(state_province_std, 'Obcina', '')
ELSE state_province_std
END;

-- Suffixes
UPDATE state_province
SET state_province_std=
CASE
WHEN state_province_std LIKE '% District' THEN REPLACE(state_province_std, 'District', '')
WHEN state_province_std LIKE '% Division' THEN REPLACE(state_province_std, 'Division', '')
WHEN state_province_std LIKE '% Municipality' THEN REPLACE(state_province_std, 'Municipality', '')
WHEN state_province_std LIKE '% Province' THEN REPLACE(state_province_std, 'Province', '')
WHEN state_province_std LIKE '% Region' THEN REPLACE(state_province_std, 'Region', '')
WHEN state_province_std LIKE '% Territory' THEN REPLACE(state_province_std, 'Territory', '')
ELSE state_province_std
END;

-- Suffixes
UPDATE state_province
SET state_province_std=TRIM(state_province_std)
;

CREATE INDEX state_province_state_province_std ON state_province (state_province_std);

