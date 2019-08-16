# OpenapiClient::WebdataFile

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**filename** | **String** | The name of the webdata file | 
**filetype** | **String** | The format of the archive file, eg &#x60;warc&#x60;, &#x60;wat&#x60;, &#x60;cdx&#x60;  | 
**checksums** | [**Object**](.md) | Verification of the content of the file.  Must include at least one of MD5 or SHA1.  The key specifies the lowercase name of the algorithm; the element is a hexadecimal string of the checksum value.  For example: {\&quot;sha1\&quot;:\&quot;6b4f32a3408b1cd7db9372a63a2053c3ef25c731\&quot;, \&quot;md5\&quot;:\&quot;766ba6fd3a257edf35d9f42a8dd42a79\&quot;}  | 
**size** | **Integer** | The size in bytes of the webdata file | [optional] 
**collection** | **Integer** | The numeric ID of the collection | [optional] 
**crawl** | **Integer** | The numeric ID of the crawl | [optional] 
**crawl_time** | **DateTime** | Time the original content of the file was crawled | [optional] 
**crawl_start** | **DateTime** | Time the crawl started | [optional] 
**locations** | **Array&lt;String&gt;** | A list of (mirrored) sources from which to retrieve (identical copies of) the webdata file, eg &#x60;https://partner.archive-it.org/webdatafile/ARCHIVEIT-4567-CRAWL_SELECTED_SEEDS-JOB1000016543-20170107214356419-00005.warc.gz&#x60;, &#x60;/ipfs/Qmee6d6b05c21d1ba2f2020fe2db7db34e&#x60;  | 

## Code Sample

```ruby
require 'OpenapiClient'

instance = OpenapiClient::WebdataFile.new(filename: null,
                                 filetype: null,
                                 checksums: null,
                                 size: null,
                                 collection: null,
                                 crawl: null,
                                 crawl_time: null,
                                 crawl_start: null,
                                 locations: null)
```


