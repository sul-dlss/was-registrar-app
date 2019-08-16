# OpenapiClient::DefaultApi

All URIs are relative to *http://localhost/wasapi/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**jobs_get**](DefaultApi.md#jobs_get) | **GET** /jobs | What jobs do I have?
[**jobs_jobtoken_get**](DefaultApi.md#jobs_jobtoken_get) | **GET** /jobs/{jobtoken} | How is my job doing?
[**jobs_jobtoken_result_get**](DefaultApi.md#jobs_jobtoken_result_get) | **GET** /jobs/{jobtoken}/result | What is the result of my job?
[**jobs_post**](DefaultApi.md#jobs_post) | **POST** /jobs | Make a new job
[**webdata_get**](DefaultApi.md#webdata_get) | **GET** /webdata | Get the archive files I need



## jobs_get

> InlineResponse200 jobs_get(opts)

What jobs do I have?

Show the jobs on this server accessible to the client

### Example

```ruby
# load the gem
require 'openapi_client'

api_instance = OpenapiClient::DefaultApi.new
opts = {
  page: 56 # Integer | One-based index for pagination 
}

begin
  #What jobs do I have?
  result = api_instance.jobs_get(opts)
  p result
rescue OpenapiClient::ApiError => e
  puts "Exception when calling DefaultApi->jobs_get: #{e}"
end
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **Integer**| One-based index for pagination  | [optional] 

### Return type

[**InlineResponse200**](InlineResponse200.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## jobs_jobtoken_get

> Job jobs_jobtoken_get(jobtoken)

How is my job doing?

Retrieve information about a job, both the parameters of its submission and its current state.  If the job is complete, the client can get the result through a separate request to `jobs/{jobtoken}/result`.

### Example

```ruby
# load the gem
require 'openapi_client'

api_instance = OpenapiClient::DefaultApi.new
jobtoken = 'jobtoken_example' # String | The job token returned from previous request

begin
  #How is my job doing?
  result = api_instance.jobs_jobtoken_get(jobtoken)
  p result
rescue OpenapiClient::ApiError => e
  puts "Exception when calling DefaultApi->jobs_jobtoken_get: #{e}"
end
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **jobtoken** | **String**| The job token returned from previous request | 

### Return type

[**Job**](Job.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## jobs_jobtoken_result_get

> FileSet jobs_jobtoken_result_get(jobtoken, opts)

What is the result of my job?

For a complete job, produces a page of the resulting files. 

### Example

```ruby
# load the gem
require 'openapi_client'

api_instance = OpenapiClient::DefaultApi.new
jobtoken = 'jobtoken_example' # String | The job token returned from previous request
opts = {
  page: 56 # Integer | One-based index for pagination 
}

begin
  #What is the result of my job?
  result = api_instance.jobs_jobtoken_result_get(jobtoken, opts)
  p result
rescue OpenapiClient::ApiError => e
  puts "Exception when calling DefaultApi->jobs_jobtoken_result_get: #{e}"
end
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **jobtoken** | **String**| The job token returned from previous request | 
 **page** | **Integer**| One-based index for pagination  | [optional] 

### Return type

[**FileSet**](FileSet.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## jobs_post

> Job jobs_post(unknown_base_type)

Make a new job

Create a job to perform some task

### Example

```ruby
# load the gem
require 'openapi_client'

api_instance = OpenapiClient::DefaultApi.new
unknown_base_type = OpenapiClient::UNKNOWN_BASE_TYPE.new # UNKNOWN_BASE_TYPE | 

begin
  #Make a new job
  result = api_instance.jobs_post(unknown_base_type)
  p result
rescue OpenapiClient::ApiError => e
  puts "Exception when calling DefaultApi->jobs_post: #{e}"
end
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **unknown_base_type** | [**UNKNOWN_BASE_TYPE**](UNKNOWN_BASE_TYPE.md)|  | 

### Return type

[**Job**](Job.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## webdata_get

> FileSet webdata_get(opts)

Get the archive files I need

Produces a page of the list of the files accessible to the client matching all of the parameters.  A parameter with multiple options matches when any option matches; a missing parameter implicitly matches. 

### Example

```ruby
# load the gem
require 'openapi_client'

api_instance = OpenapiClient::DefaultApi.new
opts = {
  page: 56, # Integer | One-based index for pagination 
  filename: 'filename_example', # String | A string exactly matching the webdata file's basename (ie must match the beginning and end of the filename, not the full path of directories). 
  crawl_time_after: DateTime.parse('2013-10-20T19:20:30+01:00'), # DateTime | Match resources that were crawled at or after the time given according to RFC3339.  A date given with no time of day means midnight.  Coordinated Universal (UTC) is preferrred and assumed if no timezone is included. Because `crawl-time-after` matches equal time stamps while `crawl-time-before` excludes equal time stamps, and because we specify instants rather than durations implicit from our units, we can smoothly scale between days and seconds.  That is, we specify ranges in the manner of the C programming language, eg low ≤ x < high.  For example, matching the month of November of 2016 is specified by `crawl-time-after=2016-11 & crawl-time-before=2016-12` or equivalently by `crawl-time-after=2016-11-01T00:00:00Z & crawl-time-before=2016-11-30T16:00:00-08:00`. 
  crawl_time_before: DateTime.parse('2013-10-20T19:20:30+01:00'), # DateTime | Match resources that were crawled strictly before the time given according to RFC3339.  See more detail at `crawl-time-after`. 
  crawl_start_after: DateTime.parse('2013-10-20T19:20:30+01:00'), # DateTime | Match resources that were crawled in a job that started at or after the time given according to RFC3339.  (Note that the original content of a file could be crawled many days after the crawl job started; would you prefer `crawl-time-after` / `crawl-time-before`?) 
  crawl_start_before: DateTime.parse('2013-10-20T19:20:30+01:00'), # DateTime | Match resources that were crawled in a job that started strictly before the time given according to RFC3339.  See more detail at `crawl-start-after`. 
  collection: 56, # Integer | The numeric ID of one or more collections, given as separate fields. For only this parameter, WASAPI accepts multiple values and will match items in any of the specified collections.  For example, matching the items from two collections can be specified by `collection=1 & collection=2`. 
  crawl: 56 # Integer | The numeric ID of the crawl 
}

begin
  #Get the archive files I need
  result = api_instance.webdata_get(opts)
  p result
rescue OpenapiClient::ApiError => e
  puts "Exception when calling DefaultApi->webdata_get: #{e}"
end
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **Integer**| One-based index for pagination  | [optional] 
 **filename** | **String**| A string exactly matching the webdata file&#39;s basename (ie must match the beginning and end of the filename, not the full path of directories).  | [optional] 
 **crawl_time_after** | **DateTime**| Match resources that were crawled at or after the time given according to RFC3339.  A date given with no time of day means midnight.  Coordinated Universal (UTC) is preferrred and assumed if no timezone is included. Because &#x60;crawl-time-after&#x60; matches equal time stamps while &#x60;crawl-time-before&#x60; excludes equal time stamps, and because we specify instants rather than durations implicit from our units, we can smoothly scale between days and seconds.  That is, we specify ranges in the manner of the C programming language, eg low ≤ x &lt; high.  For example, matching the month of November of 2016 is specified by &#x60;crawl-time-after&#x3D;2016-11 &amp; crawl-time-before&#x3D;2016-12&#x60; or equivalently by &#x60;crawl-time-after&#x3D;2016-11-01T00:00:00Z &amp; crawl-time-before&#x3D;2016-11-30T16:00:00-08:00&#x60;.  | [optional] 
 **crawl_time_before** | **DateTime**| Match resources that were crawled strictly before the time given according to RFC3339.  See more detail at &#x60;crawl-time-after&#x60;.  | [optional] 
 **crawl_start_after** | **DateTime**| Match resources that were crawled in a job that started at or after the time given according to RFC3339.  (Note that the original content of a file could be crawled many days after the crawl job started; would you prefer &#x60;crawl-time-after&#x60; / &#x60;crawl-time-before&#x60;?)  | [optional] 
 **crawl_start_before** | **DateTime**| Match resources that were crawled in a job that started strictly before the time given according to RFC3339.  See more detail at &#x60;crawl-start-after&#x60;.  | [optional] 
 **collection** | **Integer**| The numeric ID of one or more collections, given as separate fields. For only this parameter, WASAPI accepts multiple values and will match items in any of the specified collections.  For example, matching the items from two collections can be specified by &#x60;collection&#x3D;1 &amp; collection&#x3D;2&#x60;.  | [optional] 
 **crawl** | **Integer**| The numeric ID of the crawl  | [optional] 

### Return type

[**FileSet**](FileSet.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

