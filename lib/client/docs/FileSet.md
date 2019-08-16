# OpenapiClient::FileSet

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**includes_extra** | **Boolean** | When false, the data in the &#x60;files&#x60; contains nothing extraneous from what is necessary to satisfy the query or job.  When true or absent, the client must be prepared to handle irrelevant data within the referenced &#x60;files&#x60;.  | [optional] 
**count** | **Integer** | The total number of files (across all pages) | 
**files** | [**Array&lt;WebdataFile&gt;**](WebdataFile.md) |  | 

## Code Sample

```ruby
require 'OpenapiClient'

instance = OpenapiClient::FileSet.new(includes_extra: null,
                                 count: null,
                                 files: null)
```


