#! /bin/bash

# Move files from the version subdirectories to the main directory.

find . -mindepth 2 -type f -print -exec mv {} . \;
