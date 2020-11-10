# Secure configuration directory

* Contains (a) sensitive information such as password, and (b) instance-specific parameters such as paths. 
* Move this directory outside application code directory (`src`) and rename `db_config.sh.example` to `db_config.sh`
* After moving, you **MUST** change parameter `$db_config_path` in `params.sh`
