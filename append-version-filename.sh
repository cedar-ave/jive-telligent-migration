#! /bin/bash

# Files are nested in version directories. If two that are moved to the main directory have the same filename, the first will be overwritten by the second. This script attaches `-v1` for example to the file in the version `1` directory and `-v2` to the file in the version `2` directory, etc., so that when all files are moved to the main directory for upload to Telligent, they remain separate.
# Change `.zip` to another filetype if needed.


for file in */*/*.zip; do
  basename=$(basename "$file")
  dirname=$(dirname "$file")
  suffix=$(basename "$dirname")
  if [[ "$basename" != *"_${suffix}.zip" ]]; then
    mv -v "$file" "${dirname}/${basename%.zip}-v${suffix}.zip"
    fi
done
