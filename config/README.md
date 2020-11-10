# Secure configuration directory

* Contains sensitive information such as passwords
* Move this directory outside (above) application code directory (`src`) and rename `db_config.sh.example` to `db_config.sh`
* After moving, you **MUST** change parameter `$db_config_path` in `params.sh`
