#!/bin/sh

# A binary file in Jive may have historical versions. Each time a file is replaced in Jive, a version is created. For specified files (`ContentIDs`), this script:
## (1) Makes a directory named with the `ContentID`, identifies the number of versions of that Jive file, creates a directory for each version, and downloads that version's file there (this is to prevent files with identical filenames overwriting one another)
## (2) Appends the `updated` (not `lastActivity`) date to the end of the filename to provide a record of when that version was uploaded (the `updated` date of the first version is the same as the `published` date so it works for both the first and subsequent versions)

for contentID in 1234 5678 ; do

mkdir $contentID
cd $contentID

curl -u "username:password" -H "Content-Type: application/json" https://<yourinstance>.jiveon.com/api/core/v3/contents/$contentID > 1.txt
jq '.version' <1.txt > 2.txt
version=$(< 2.txt)

for i in $(seq 1 $version); do

mkdir $i
cd $i

curl -u "username:password" -H "Content-Type: application/json" https://<yourinstance>.jiveon.com/api/core/v3/versions/$contentID/$i | jq -r '.updated' > 5.txt
head -c10 <5.txt >5a.txt

sed 's/T/_/g;' <5a.txt >5b.txt
date=$(< 5b.txt)

curl -u "username:password" -H "Content-Type: application/json" https://<yourinstance>.jiveon.com/api/core/v3/versions/$contentID/$i | jq -r '.content.name' > 6.txt
file=$(< 6.txt)

curl -u "username:password" https://<yourinstance>.jiveon.com/api/core/v3/versions/$contentID/$i/data -O -J -L
for file in *.zip; do mv "$file" `echo $file | tr ' ' '_'`; done
for file in *.zip; do mv $file $(basename $file .zip)_$date.zip; done
cd ..

done
cd ..
done
cd ..
done
