-- -----------------------------------------------------------------
-- Populate metadata table "collaborator" of project collaborators
-- Requires table collaborator_raw, imported from manually prepared
-- CSV file 'collaborators.csv' in data directory
-- -----------------------------------------------------------------

INSERT INTO collaborator (
collaborator_name,
collaborator_name_full,
collaborator_url,
description,
logo_path
)
SELECT 
collaborator_name,
collaborator_name_full,
collaborator_url,
description,
logo_path
FROM collaborator_raw
;
