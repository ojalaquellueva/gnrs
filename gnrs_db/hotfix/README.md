# GNRS hotfixes

Directory hotfix contains code which implements backwards-compatible database changes implemented as "hotfixes" on the live system. For the GNRS and other BIEN web services, major and minor versions are almost always associated with a complete rebuild of the application database (data warehouse) via the database pipeline (e.g., code in gnrs_db/). All hotfixes made after the last minor version release are incorporated into the next minor or major release (whichever comes first).

Each patch results in a version increment. Keep each script or set of scripts associated with a particular hotfix/patch in a separate subdirectory named for the version. As code stored in hotfix/ subdirectories always involves changes the database, the subdirectories are assigned the number of the associated **database version**, as follows:

```
hotfix/
 |__ 2.2.1/
 |__ 2.2.2/
 |__ 2.2.3/

```

After executing the hotfix, also do the following:

* Commit & tag code changes
* Push the commit and tags to remote main repo
* Push/pull from remote to production instance(s). 
* Update all relevant version information in table "meta" in the GNRS database.

If the hotfix involves changes to the database, either:  

* Execute changes on all database instances --OR--  
* Dump new (development) database and restore to all production instances
