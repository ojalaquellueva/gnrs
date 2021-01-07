# Configuration directory 

* Contains sensitive information such as passwords & server-specific parameters such as the base application path
* After setting all parameters, move this directory & contents outside application code directory (`src`)
* Applications scripts load these con figuration files using path `../config/`. For example:

```
source "../config/db_config.sh"
```

* therefore you **MUST** move this directory to the above location