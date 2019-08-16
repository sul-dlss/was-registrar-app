# OpenapiClient::Job

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**jobtoken** | **String** | Identifier unique across the implementation.  Archive-It has chosen to use an increasing integer.  | 
**function** | [**Function**](Function.md) |  | 
**query** | **String** | The specification of what webdata to include in the job.  Encoding is URL-style, eg &#x60;param&#x3D;value&amp;otherparam&#x3D;othervalue&#x60;.  | 
**submit_time** | **DateTime** | Time of submission, formatted according to RFC3339 | 
**termination_time** | **DateTime** | Time of completion or failure, formatted according to RFC3339  | [optional] 
**state** | **String** | The state of the job through its lifecycle. &#x60;queued&#x60;:  Job has been submitted and is waiting to run. &#x60;running&#x60;:  Job is currently running. &#x60;failed&#x60;:  Job ran but failed. &#x60;complete&#x60;:  Job ran and successfully completed; result is available. &#x60;gone&#x60;:  Job ran, but the result is no longer available (eg deleted   to save storage).  | 

## Code Sample

```ruby
require 'OpenapiClient'

instance = OpenapiClient::Job.new(jobtoken: null,
                                 function: null,
                                 query: null,
                                 submit_time: null,
                                 termination_time: null,
                                 state: null)
```


