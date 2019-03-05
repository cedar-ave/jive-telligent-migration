# jive-telligent-migration
Extract binaries from Jive and upload them to Telligent

The following steps rely on [Jive Search Service filters](https://developers.jivesoftware.com/api/v3/cloud/rest/SearchService.html#searchContents).

## Step 1: Get `placeID`
```
https://<yourinstance>.jiveon.com/api/core/v3/places?filter=type(space,group)&fields=-resources,placeID,displayName,-id,-typeCode&count=100&startIndex=0
```

Change `startIndex` to `100`, then `200`, etc., if it is not returned the first time.


## Step 2: Get `contentID`s
Note that in the Jive API there is an `id` and a `contentID`. `contentID` is required, not `id`.

Add the `placeID` in the `place` filter:

```
https://<yourinstance>.jiveon.com/api/core/v3/contents?fields=contentId,subject,contentType,name,-resources&filter=type(file)&filter=place(http://<yourinstance>.jiveon.com/api/core/v3/places/1069)&count=100&startIndex=0
```
