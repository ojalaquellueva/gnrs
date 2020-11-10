# Secure configuration directory

* Contains sensitive information such as passwords, for API
* Move this directory outside (above) application code directory (`src`) and rename `db_config.php.example` to `db_config.php`
* After moving, you **MUST** change parameter `$CONFIG_DIR` in `server_params.php`
