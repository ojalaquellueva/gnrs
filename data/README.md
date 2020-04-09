# Common data directory

* Files for building database go in subdirectory "db"
* GNRS user-supplied input files go in subdirectory "user"
* GNRS results files are also written to subdirectory "user"
* If you move these directories you must change parameters $db_data_dir and $user_data_dir accordingly. See shared params file.   
* Recommend moving this directory outside its default location inside application code directory
