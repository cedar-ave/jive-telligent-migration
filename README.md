# jive-telligent-migration
Extract binaries from Jive and upload them to Telligent.

The following steps rely on [Jive Search Service filters](https://developers.jivesoftware.com/api/v3/cloud/rest/SearchService.html#searchContents).

**Step 1: Get Jive `placeID`.**
```
https://<yourinstance>.jiveon.com/api/core/v3/places?filter=type(space,group)&fields=-resources,placeID,displayName,-id,-typeCode&count=100&startIndex=0
```

Change `startIndex` to `100`, then `200`, etc., if it is not returned the first time.


**Step 2: Get Jive `contentID`s.**
Note that in the Jive API there is an `id` and a `contentID`. `contentID` is required, not `id`.

Add the `placeID` in the `place` filter:

```
https://<yourinstance>.jiveon.com/api/core/v3/contents?fields=contentId,subject,contentType,name,-resources&filter=type(file)&filter=place(http://<yourinstance>.jiveon.com/api/core/v3/places/1069)&count=100&startIndex=0
```

**Step 3: Extract each version of Jive files.**
Populate and run `extract-from-jive.sh`.

**Step 4: Append the version number to the filename so files don't overwrite one another when moved to the main directory.**
Run `append-version-filename.sh`.

**Step 5 (optional)**
If extracting .zip files, it can be helpful to understand when a file was zipped to indentify whether two stored versions are identical. Run `zip-dates.sh`.

**Step 6: Move files to a main directory.**
Run `move-files.sh`.

**Step 7: Create a JSON file of all filenames, titles, and tags.**
For example:
```
[
	{
		"filename": "abc_2016_04_04.zip",
		"title": "ABC Installer (4 April 2016)",
		"tags": "tag1,tag2,tag3"
	},
	{
		"filename": "def_2017_05_10.zip",
		"title": "DEF Installer (5 October 2017)",
		"tags": "tag1,tag4,tag5"
	}
]
```

**Step 8: Upload to Telligent.**
Run `upload-telligent.sh`.

**Step 9: Create table of contents in Telligent of the uploaded files.**
Run `create-toc.sh`.





