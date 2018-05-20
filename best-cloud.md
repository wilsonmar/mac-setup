cloud-settings.md

<strong>"best_cloud"</strong> README.md

What cloud region should you run your work?

## Manual specification

This may on the surface seem to be a trivial issue.

Just look up the region name on the cloud vendor's map in relation to where you are 
and simply type that code in the script, such as:

   <pre>
AWS_REGION="us-west-1"  // TODO: url to list of regions
 AZ_REGION="us-west-1"
GCP_REGION="us-west-1"
   </pre>

See https://wilsonmar.github.io/cloud-services-comparisons/

## Automatic region selection

However, it's not that I'm too "lazy" to look it up.

This script can be run anywhere in the world.

Without this, bash scripts today need to involve a <strong>human manual</strong> 
step, or be wrong and thus run slower and more expensively.

Also, a particular region can be operating slower than others, and a job that involves a lot of data transfer in and out of a cloud instance would <strong>get best performance</strong> by using whatever cloud region is fastest at a particular time, again, without manual intervention.

The fastest_region is determined from the response JSON and
placed in a memory variable for use in the script.


## Obtaining cloud speed

To obtain speeds <strong>from the local client each time</strong> 
a program running on the local laptop to make API calls 
measures the speed and other qualities of each interaction.
Kinda like using <a target="_blank" href="https://cloudping.info/">cloudping.info</a> 
and <a target="_blank" href="https://speedtest.net">https://speedtest.net</a>,
but measuring the link to <strong>servers within clouds</strong> rather some random server.

Also, the program hits several servers in various regions rather than just one server
as speedtest does.

The response JSON is used to determine the "best_region" 
placed in a memory variable for use in the script.


## More Factors for selection

There are actually several factors in determining what region/zone should be used at any given time:

1. If none of the additional conditions below applies, you may want to select the region that your laptop reaches the quickest.

   That's where this <strong>"best_cloud"</strong> API can help you.
   This a Serverless component running on all three of the major clouds:

   However life may not be that simple ...

2. Some services are restricted to working on specific regions/zones while they are being developed.

3. Some services restrict you to use the region/zone associated with where your client machine is working. This is usually based on the IP address setup for your laptop.

4. Aside for outright restrictions, some services <strong>charge more</strong> if you cross region/zone boundaries.

5. Some regions/zones are more expensive to use than others. For example, Amazon charges more for servers and Lambda calls in Europe than in the US.

6. Severless frameworks are now available to enable a single app service codebase that can run on several clouds. This enable a particular task to run on whatever is the fastest or <strong>least expensive option</strong> at runtime.


<a name="limitations"></a>

## Limitations and value added

To avoid abuse, each IP address is allowed up to 10 anonymous accesses each 24 hour period.
A return code of 501 is returned after that.

Please register to send up to 100 calls per day when calls contains a HTTP HEADER containing your registration CODE.

To send more, we can't afford it unless you help us pay the bills.

## Auto-assign based on speed

Those who subscribe can specify an IP ranges and designated region codes.


## MVP development sequence

The list below is the "MVP" sequence over time to develop features (objective) of this script for an automated way to figure out:

1. the speed to a single region within AWS
2. the fastest cloud Region within AWS

3. the speed to a single region within Azure
4. the fastest cloud Region within Azure
5. the fastest cloud vendor and Region between AWS and Azure

6. the speed to a single region within GCP
7. the fastest cloud Region within GCP
8. the fastest cloud vendor and Region between AWS, Azure, and GCP

9. the optimal cloud vendor and Region based on additional parameters provided by the client
9. the optimal cloud vendor and Region based on additional parameters stored in the cloud

Ultimately, calls to "best-cloud" can be setup to run regularly on a timer to capture timings over time so the system can <strong>predict the best time</strong>


Now for the technical side of how to make calls:

### AWS Lambda

   <pre>AWS_REGION=$( TODO: Lambda function call | grep fastest_region )
   </pre>

   The Lambda call to the Amazon API Gateway: 

   <pre>
POST /2015-03-31/functions/<em>FunctionArn</em>/invocations?Qualifier=Qualifier HTTP/1.1 
X-Amz-Invocation-Type: Event 
...
Authorization: ...
Content-Type: application/json
Content-Length: <em>PayloadSize</em>
   </pre>

   The "2015-03-31" is the version for utility API processing.

   The <em>FunctionArn</em> above is the ARN of the Lambda function to be invoked.

   See https://docs.aws.amazon.com/apigateway/latest/developerguide/integrating-api-with-aws-services-lambda.html

### Microsoft Azure Function

   <pre>https://<em>Your Function App</em>.azurewebsites.net/api/<em>Your Function Name>?code=<your access code</em>
   </pre>

   See https://docs.microsoft.com/en-us/azure/azure-functions/functions-test-a-function

### GCP Function

   <pre>GCP_REGION= TODO: Google Functions call
   </pre>

   See https://cloud.google.com/functions/docs/writing/http
   and https://cloud.google.com/functions/docs/tutorials/http
   
## Setting 

In Amazon, 

   <pre>aws config set compute/zone $AWS_REGION
   </pre>

In Microsoft Azure cloud:

   <pre>az config set compute/zone $AZ_REGION
   </pre>

In GCP:

   <pre>gcloud config set compute/zone $GCP_REGION
   </pre>

