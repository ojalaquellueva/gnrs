-- ------------------------------------------------------------------
-- Fixes misc errors in GNRS state_province tables
-- ------------------------------------------------------------------

-- 
-- state_province
-- 
UPDATE state_province
SET 
state_province_ascii='Estado de Veracruz',
state_province_std='Veracruz'
WHERE country_iso='MX'  
AND state_province_ascii='Estado de Veracruz-Llave'
;
UPDATE state_province
SET 
state_province_ascii='Estado de Michoacan',
state_province_std='Michoacan'
WHERE country_iso='MX'  
AND state_province_ascii='Estado de Michoacan de Ocampo'
;
UPDATE state_province
SET 
state_province_ascii='Estado de Coahuila',
state_province_std='Coahuila'
WHERE country_iso='MX'  
AND state_province_ascii='Estado de Coahuila de Zaragoza'
;
UPDATE state_province
SET 
state_province_ascii='Provincia de Camaguey',
state_province_std='Camaguey'
WHERE country_iso='CU'  
AND state_province_ascii='Provincia de Camagueey'
;
UPDATE state_province
SET 
state_province='Kuna Yala',
state_province_ascii='Kuna Yala',
state_province_std='Kuna Yala'
WHERE country_iso='PA'  
AND state_province='Guna Yala'
;


-- 
-- state_province_name
-- 
INSERT INTO state_province_name (
state_province_id,
state_province_name
)
VALUES 
(
(select state_province_id from state_province where country_iso='CU'  
AND state_province='La Habana'),
('Ciudad de la Habana')
),
(
(select state_province_id from state_province where country_iso='PE'  
AND state_province='Provincia de Lima'),
('Lima Province')
),
(
(select state_province_id from state_province where country_iso='PA'  
AND state_province_ascii='Embera-Wounaan'),
('Embera')
),
(
(select state_province_id from state_province where country_iso='PA'  
AND state_province_ascii='Embera-Wounaan'),
('Emberá')
)
;