# Secure configuration directory

* Contains (a) sensitive information such as password, and (b) instance-specific parameters such as paths. 
* Recommend moving this directory outside its default location inside application code directory
* If you move this directory you **MUST** change parameters $db_config_path (in params.sh) and $$CONFIG_DIR (in params.php) accordingly. 
* Keeping instance-specific parameters such as paths in this directory allows you to update multiple instances (e.g., development and production) from the same repo without having to change the configuration parameters.
