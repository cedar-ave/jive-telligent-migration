#!/bin/sh

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
