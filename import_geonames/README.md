# Downloads geonames files and populates database geonames

## Source: https://gist.github.com/bbinet/3635232
## ORIGINAL AUTHOR: Andreas (aka Harpagophyt)

### Details

Will create database geonames. Aborts if database geonames already exists.
Files will be downloaded to <data_directory>.

### Usage

```
sudo -u postgres ./import_geonames.sh <path/to/data_directory>

```

### Warnings
* Recommend create <data_directory> in advance, and assign it to group 'postgres', e.g., 

```
$ chgrp postgres <data_directory>

```

