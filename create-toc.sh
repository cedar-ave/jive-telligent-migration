#! /bin/bash

# This script prints out filenames and URLs to create a table of contents in Telligent for the files uploaded to Telligent

for ((i=0; ; i+=1)); do
    objects=$(curl -H "Rest-User-Token: 12345" -X GET "https://<yourinstance>/api.ashx/v2/media/16/files.json?PageIndex=$i&PageSize=100&SortBy=Subject")
    echo "$objects" > $i.json
    if jq -e '.MediaPosts | length == 0' >/dev/null; then 
       break
    fi <<< "$objects"
    jq -r '.MediaPosts[] | "<a href=\"" + .Url + "\">" + .Content.HtmlName + "</a>"' <<< "$objects" > $i.json
done
