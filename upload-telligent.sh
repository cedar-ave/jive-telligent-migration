#!/bin/sh

# This script uploads binary files in a directory to Telligent, based on their filename, and assigns a desired title and tags.
# Run this script in a directory of binary files to upload to Telligent.
# This script uses the Telligent CFS endpoint. It splits the file into chunks of up to 10MB and uploads them a chunk at a time, starting with 0/X chunks. They all have the same UUID (automatically generated in the script). Then this UUID is used to unify the chunks and upload to a media gallery.
# Use https://community.telligent.com/community/10/w/api-documentation/61584/list-gallery-rest-endpoint to find the media gallery ID.
# Create a JSON file that has keys for the filename (must match the actual filename), desired title, and desired tags. Create an object for each file to upload. See `readme.md` for more details.



jq -r '.[] | "\(.filename)|\(.title)|\(.tags)"' key.json |
    while IFS="|" read -r filename title tags; do

# This generates a random UUID
uuid=$(od -x /dev/urandom | head -1 | awk '{OFS="-"; print $2$3,$4,$5,$6,$7$8$9}')

for file in $filename; do


split -b10M -a3 --numeric-suffixes=100 $file part.
partlist=( part.* )
numparts=${#partlist[@]}
for part in ${partlist[@]}; do
 i=$(( ${part##*.}-100 ))

curl -Si \
 https://<yourinstance>.com/api.ashx/v2/cfs/temporary.json \
  -H 'Rest-User-Token: 123456' \
  -F UploadContextId=$uuid \
  -F FileName=$file \
  -F TotalChunks=$numparts \
  -F CurrentChunk="$i" \
  -F 'file=@'$part

done
rm ${partlist[@]}

curl -Si \
  https://<yourinstance>.com/api.ashx/v2/media/<media gallery id>/files.json \
  -H 'Rest-User-Token: 123456' \
  -F ContentType=application/zip \
  -F FileName=$file \
  -F FileUploadContext=$uuid \
  -F "Name=$title" \
  -F "Tags=$tags"

done
done
