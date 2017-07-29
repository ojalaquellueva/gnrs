Preparing raw traits file for export

Starting files: 
stateProvince.txt
countyParish.txt

Both are CSVs, despite extension

Convert to UTF-8
iconv -f ISO-8859-1 -t UTF-8 stateProvince.txt > stateProvince_utf8.csv
iconv -f ISO-8859-1 -t UTF-8 countyParish.txt > countyParish_utf8.csv
