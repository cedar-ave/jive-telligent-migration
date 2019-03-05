#! /bin/bash

# (Optional script)
# Retrieve the date each file was zipped.


for D in */*; do
    if [ -d "${D}" ]; then
     cd $D
     fn=$(readlink -m *.zip)
find . -maxdepth 1 -name '*.zip' | unzip -Zl *.zip | sed '1,2d;$d' | sed "s|^|${D}|" | sed "s|^|${fn}|" |  head -n 1   >> ../../zip.txt
cd ..
cd ..
    fi
done
