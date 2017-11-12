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
WHEN county_parish_std ILIKE 'Municipio de%' THEN regexp_replace(county_parish_std, 'Municipio de', '', 'i')
WHEN county_parish_std ILIKE 'Canton de%' THEN regexp_replace(county_parish_std, 'Canton de', '', 'i')
WHEN county_parish_std ILIKE 'Castello di%' THEN regexp_replace(county_parish_std, 'Castello di', '', 'i')
WHEN county_parish_std ILIKE 'Commune de%' THEN regexp_replace(county_parish_std, 'Commune de', '', 'i')
WHEN county_parish_std ILIKE 'Concelho do%' THEN regexp_replace(county_parish_std, 'Concelho do', '', 'i')
WHEN county_parish_std ILIKE 'Concelho da%' THEN regexp_replace(county_parish_std, 'Concelho da', '', 'i')
WHEN county_parish_std ILIKE 'Concelho de%' THEN regexp_replace(county_parish_std, 'Concelho de', '', 'i')
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
WHEN county_parish_std ILIKE 'Municipio Especial%' THEN regexp_replace(county_parish_std, 'Municipio Especial', '', 'i')
WHEN county_parish_std ILIKE 'Parish of%' THEN regexp_replace(county_parish_std, 'Parish of', '', 'i')
WHEN county_parish_std ILIKE 'Prefecture de la%' THEN regexp_replace(county_parish_std, 'Prefecture de la', '', 'i')
WHEN county_parish_std ILIKE 'Prefecture de%' THEN regexp_replace(county_parish_std, 'Prefecture de', '', 'i')
WHEN county_parish_std ILIKE 'Principality of%' THEN regexp_replace(county_parish_std, 'Principality of', '', 'i')
WHEN county_parish_std ILIKE 'Province of%' THEN regexp_replace(county_parish_std, 'Province of', '', 'i')
WHEN county_parish_std ILIKE 'Provincia del%' THEN regexp_replace(county_parish_std, 'Provincia del', '', 'i')
WHEN county_parish_std ILIKE 'Provincia de%' THEN regexp_replace(county_parish_std, 'Provincia de', '', 'i')
WHEN county_parish_std ILIKE 'Province du%' THEN regexp_replace(county_parish_std, 'Province du', '', 'i')
WHEN county_parish_std ILIKE 'Province de%' THEN regexp_replace(county_parish_std, 'Province de', '', 'i')
WHEN county_parish_std ILIKE 'Qarku i%' THEN regexp_replace(county_parish_std, 'Qarku i', '', 'i')
WHEN county_parish_std ILIKE 'Region del%' THEN regexp_replace(county_parish_std, 'Region del', '', 'i')
WHEN county_parish_std ILIKE 'Region du%' THEN regexp_replace(county_parish_std, 'Region du', '', 'i')
WHEN county_parish_std ILIKE 'Region de%' THEN regexp_replace(county_parish_std, 'Region de', '', 'i')
WHEN county_parish_std ILIKE 'Region de%' THEN regexp_replace(county_parish_std, 'Region de', '', 'i')
WHEN county_parish_std ILIKE 'State of%' THEN regexp_replace(county_parish_std, 'State of', '', 'i')
WHEN county_parish_std ILIKE 'Union Territory of%' THEN regexp_replace(county_parish_std, 'Union Territory of', '', 'i')
WHEN county_parish_std ILIKE 'Wilaya de%' THEN regexp_replace(county_parish_std, 'Wilaya de', '', 'i')
ELSE county_parish_std
END;

-- Prefixes without articles
UPDATE county_parish
SET county_parish_std=
CASE
WHEN county_parish_std ILIKE 'Canton%' THEN regexp_replace(county_parish_std, 'Canton', '', 'i')
WHEN county_parish_std ILIKE 'Municipio%' THEN regexp_replace(county_parish_std, 'Municipio', '', 'i')
WHEN county_parish_std ILIKE 'County%' THEN regexp_replace(county_parish_std, 'Canton', '', 'i')
WHEN county_parish_std ILIKE 'Kanton%' THEN regexp_replace(county_parish_std, 'Kanton', '', 'i')
WHEN county_parish_std ILIKE 'Concelho%' THEN regexp_replace(county_parish_std, 'Concelho', '', 'i')
WHEN county_parish_std ILIKE 'Departamento%' THEN regexp_replace(county_parish_std, 'Departamento', '', 'i')
WHEN county_parish_std ILIKE 'Departament%' THEN regexp_replace(county_parish_std, 'Departament', '', 'i')
WHEN county_parish_std ILIKE 'Departement%' THEN regexp_replace(county_parish_std, 'Departement', '', 'i')
WHEN county_parish_std ILIKE 'Distrito%' THEN regexp_replace(county_parish_std, 'Distrito', '', 'i')
WHEN county_parish_std ILIKE 'Estado%' THEN regexp_replace(county_parish_std, 'Estado', '', 'i')
WHEN county_parish_std ILIKE 'Gouvernorat%' THEN regexp_replace(county_parish_std, 'Gouvernorat', '', 'i')
WHEN county_parish_std ILIKE 'Parish%' THEN regexp_replace(county_parish_std, 'Parish', '', 'i')
WHEN county_parish_std ILIKE 'Prefecture%' THEN regexp_replace(county_parish_std, 'Prefecture', '', 'i')
WHEN county_parish_std ILIKE 'Principality%' THEN regexp_replace(county_parish_std, 'Principality', '', 'i')
WHEN county_parish_std ILIKE 'Province%' THEN regexp_replace(county_parish_std, 'Province', '', 'i')
WHEN county_parish_std ILIKE 'Provincia%' THEN regexp_replace(county_parish_std, 'Provincia', '', 'i')
WHEN county_parish_std ILIKE 'Provinsi%' THEN regexp_replace(county_parish_std, 'Provinsi', '', 'i')
WHEN county_parish_std ILIKE 'Region%' THEN regexp_replace(county_parish_std, 'Region', '', 'i')
WHEN county_parish_std ILIKE 'State%' THEN regexp_replace(county_parish_std, 'State', '', 'i')
WHEN county_parish_std ILIKE 'Union Territory%' THEN regexp_replace(county_parish_std, 'Union Territory', '', 'i')
WHEN county_parish_std ILIKE 'Wilaya%' THEN regexp_replace(county_parish_std, 'Wilaya', '', 'i')
WHEN county_parish_std ILIKE 'Tinh%' THEN regexp_replace(county_parish_std, 'Tinh', '', 'i')
WHEN county_parish_std ILIKE 'Changwat%' THEN regexp_replace(county_parish_std, 'Changwat', '', 'i')
WHEN county_parish_std ILIKE 'ChanObcinagwat%' THEN regexp_replace(county_parish_std, 'Obcina', '', 'i')
ELSE county_parish_std
END;

-- Suffixes
UPDATE county_parish
SET county_parish_std=
CASE
WHEN county_parish_std ILIKE '% District' THEN regexp_replace(county_parish_std, 'District', '', 'i')
WHEN county_parish_std ILIKE '% County' THEN regexp_replace(county_parish_std, 'County', '', 'i')
WHEN county_parish_std ILIKE '% Parish' THEN regexp_replace(county_parish_std, 'Parish', '', 'i')
WHEN county_parish_std ILIKE '% Division' THEN regexp_replace(county_parish_std, 'Division', '', 'i')
WHEN county_parish_std ILIKE '% Municipality' THEN regexp_replace(county_parish_std, 'Municipality', '', 'i')
WHEN county_parish_std ILIKE '% Municipio' THEN regexp_replace(county_parish_std, 'Municipio', '', 'i')
WHEN county_parish_std ILIKE '% Province' THEN regexp_replace(county_parish_std, 'Province', '', 'i')
WHEN county_parish_std ILIKE '% Region' THEN regexp_replace(county_parish_std, 'Region', '', 'i')
WHEN county_parish_std ILIKE '% Territory' THEN regexp_replace(county_parish_std, 'Territory', '', 'i')
ELSE county_parish_std
END;

-- Suffixes
UPDATE county_parish
SET county_parish_std=TRIM(county_parish_std)
;

CREATE INDEX county_parish_county_parish_std ON county_parish (county_parish_std);

