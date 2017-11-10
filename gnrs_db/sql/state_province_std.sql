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
WHEN state_province_std ILIKE 'Canton de%' THEN regexp_replace(state_province_std, 'Canton de', '', 'i')
WHEN state_province_std ILIKE 'Castello di%' THEN regexp_replace(state_province_std, 'Castello di', '', 'i')
WHEN state_province_std ILIKE 'Commune de%' THEN regexp_replace(state_province_std, 'Commune de', '', 'i')
WHEN state_province_std ILIKE 'Concelho do%' THEN regexp_replace(state_province_std, 'Concelho do', '', 'i')
WHEN state_province_std ILIKE 'Concelho da%' THEN regexp_replace(state_province_std, 'Concelho da', '', 'i')
WHEN state_province_std ILIKE 'Concelho de%' THEN regexp_replace(state_province_std, 'Concelho de', '', 'i')
WHEN state_province_std ILIKE 'Departamento del%' THEN regexp_replace(state_province_std, 'Departamento del', '', 'i')
WHEN state_province_std ILIKE 'Departamento de%' THEN regexp_replace(state_province_std, 'Departamento de', '', 'i')
WHEN state_province_std ILIKE 'Departament of%' THEN regexp_replace(state_province_std, 'Departament of', '', 'i')
WHEN state_province_std ILIKE 'Departement de%' THEN regexp_replace(state_province_std, 'Departement de', '', 'i')
WHEN state_province_std ILIKE 'Distrito del%' THEN regexp_replace(state_province_std, 'Distrito del', '', 'i')
WHEN state_province_std ILIKE 'Distrito da%' THEN regexp_replace(state_province_std, 'Distrito da', '', 'i')
WHEN state_province_std ILIKE 'Distrito do%' THEN regexp_replace(state_province_std, 'Distrito do', '', 'i')
WHEN state_province_std ILIKE 'Distrito de%' THEN regexp_replace(state_province_std, 'Distrito de', '', 'i')
WHEN state_province_std ILIKE 'Estado de%' THEN regexp_replace(state_province_std, 'Estado de', '', 'i')
WHEN state_province_std ILIKE 'Gouvernorat de%' THEN regexp_replace(state_province_std, 'Gouvernorat de', '', 'i')
WHEN state_province_std ILIKE 'Municipio Especial%' THEN regexp_replace(state_province_std, 'Municipio Especial', '', 'i')
WHEN state_province_std ILIKE 'Parish of%' THEN regexp_replace(state_province_std, 'Parish of', '', 'i')
WHEN state_province_std ILIKE 'Prefecture de la%' THEN regexp_replace(state_province_std, 'Prefecture de la', '', 'i')
WHEN state_province_std ILIKE 'Prefecture de%' THEN regexp_replace(state_province_std, 'Prefecture de', '', 'i')
WHEN state_province_std ILIKE 'Principality of%' THEN regexp_replace(state_province_std, 'Principality of', '', 'i')
WHEN state_province_std ILIKE 'Province of%' THEN regexp_replace(state_province_std, 'Province of', '', 'i')
WHEN state_province_std ILIKE 'Provincia del%' THEN regexp_replace(state_province_std, 'Provincia del', '', 'i')
WHEN state_province_std ILIKE 'Provincia de%' THEN regexp_replace(state_province_std, 'Provincia de', '', 'i')
WHEN state_province_std ILIKE 'Province du%' THEN regexp_replace(state_province_std, 'Province du', '', 'i')
WHEN state_province_std ILIKE 'Province de%' THEN regexp_replace(state_province_std, 'Province de', '', 'i')
WHEN state_province_std ILIKE 'Qarku i%' THEN regexp_replace(state_province_std, 'Qarku i', '', 'i')
WHEN state_province_std ILIKE 'Region del%' THEN regexp_replace(state_province_std, 'Region del', '', 'i')
WHEN state_province_std ILIKE 'Region du%' THEN regexp_replace(state_province_std, 'Region du', '', 'i')
WHEN state_province_std ILIKE 'Region de%' THEN regexp_replace(state_province_std, 'Region de', '', 'i')
WHEN state_province_std ILIKE 'Region de%' THEN regexp_replace(state_province_std, 'Region de', '', 'i')
WHEN state_province_std ILIKE 'State of%' THEN regexp_replace(state_province_std, 'State of', '', 'i')
WHEN state_province_std ILIKE 'Union Territory of%' THEN regexp_replace(state_province_std, 'Union Territory of', '', 'i')
WHEN state_province_std ILIKE 'Wilaya de%' THEN regexp_replace(state_province_std, 'Wilaya de', '', 'i')
ELSE state_province_std
END;

-- Prefixes without articles
UPDATE state_province
SET state_province_std=
CASE
WHEN state_province_std ILIKE 'Canton%' THEN regexp_replace(state_province_std, 'Canton', '', 'i')
WHEN state_province_std ILIKE 'Kanton%' THEN regexp_replace(state_province_std, 'Kanton', '', 'i')
WHEN state_province_std ILIKE 'Concelho%' THEN regexp_replace(state_province_std, 'Concelho', '', 'i')
WHEN state_province_std ILIKE 'Departamento%' THEN regexp_replace(state_province_std, 'Departamento', '', 'i')
WHEN state_province_std ILIKE 'Departament%' THEN regexp_replace(state_province_std, 'Departament', '', 'i')
WHEN state_province_std ILIKE 'Departement%' THEN regexp_replace(state_province_std, 'Departement', '', 'i')
WHEN state_province_std ILIKE 'Distrito%' THEN regexp_replace(state_province_std, 'Distrito', '', 'i')
WHEN state_province_std ILIKE 'Estado%' THEN regexp_replace(state_province_std, 'Estado', '', 'i')
WHEN state_province_std ILIKE 'Gouvernorat%' THEN regexp_replace(state_province_std, 'Gouvernorat', '', 'i')
WHEN state_province_std ILIKE 'Parish%' THEN regexp_replace(state_province_std, 'Parish', '', 'i')
WHEN state_province_std ILIKE 'Prefecture%' THEN regexp_replace(state_province_std, 'Prefecture', '', 'i')
WHEN state_province_std ILIKE 'Principality%' THEN regexp_replace(state_province_std, 'Principality', '', 'i')
WHEN state_province_std ILIKE 'Province%' THEN regexp_replace(state_province_std, 'Province', '', 'i')
WHEN state_province_std ILIKE 'Provincia%' THEN regexp_replace(state_province_std, 'Provincia', '', 'i')
WHEN state_province_std ILIKE 'Provinsi%' THEN regexp_replace(state_province_std, 'Provinsi', '', 'i')
WHEN state_province_std ILIKE 'Region%' THEN regexp_replace(state_province_std, 'Region', '', 'i')
WHEN state_province_std ILIKE 'State%' THEN regexp_replace(state_province_std, 'State', '', 'i')
WHEN state_province_std ILIKE 'Union Territory%' THEN regexp_replace(state_province_std, 'Union Territory', '', 'i')
WHEN state_province_std ILIKE 'Wilaya%' THEN regexp_replace(state_province_std, 'Wilaya', '', 'i')
WHEN state_province_std ILIKE 'Tinh%' THEN regexp_replace(state_province_std, 'Tinh', '', 'i')
WHEN state_province_std ILIKE 'Changwat%' THEN regexp_replace(state_province_std, 'Changwat', '', 'i')
WHEN state_province_std ILIKE 'Obcina%' THEN 
regexp_replace(state_province_std, 'Obcina', '', 'i')
WHEN state_province_std ILIKE 'Ile du %' THEN 
regexp_replace(state_province_std, 'Ile du ', '', 'i')
WHEN state_province_std ILIKE 'Ile %' THEN 
regexp_replace(state_province_std, 'Ile ', '', 'i')
ELSE state_province_std
END;

-- Suffixes
UPDATE state_province
SET state_province_std=
CASE
WHEN state_province_std ILIKE '% District' THEN regexp_replace(state_province_std, 'District', '', 'i')
WHEN state_province_std ILIKE '% Division' THEN regexp_replace(state_province_std, 'Division', '', 'i')
WHEN state_province_std ILIKE '% Municipality' THEN regexp_replace(state_province_std, 'Municipality', '', 'i')
WHEN state_province_std ILIKE '% Province' THEN regexp_replace(state_province_std, 'Province', '', 'i')
WHEN state_province_std ILIKE '% Region' THEN regexp_replace(state_province_std, 'Region', '', 'i')
WHEN state_province_std ILIKE '% Territory' THEN regexp_replace(state_province_std, 'Territory', '', 'i')
WHEN state_province_std ILIKE '% Island' THEN regexp_replace(state_province_std, 'Island', '', 'i')
WHEN state_province_std ILIKE '% Islands' THEN regexp_replace(state_province_std, 'Islands', '', 'i')
ELSE state_province_std
END;

UPDATE state_province
SET state_province_std=TRIM(state_province_std)
;

CREATE INDEX state_province_state_province_std ON state_province (state_province_std);

